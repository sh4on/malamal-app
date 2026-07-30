import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../base/controllers/base_controller.dart';
import '../../../core/services/network_service.dart';
import '../screens/widgets/payment_webview_screen.dart';

// portpos redirect success url — the webview detects fail/cancel via url substrings
const String _kPortPosSuccessUrl = 'https://malamal.com.bd/payment/success';

/// checkout flow controller — handles /order/checkout POST and payment routing
class CheckoutController extends GetxController {
  // billing info form text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController couponController = TextEditingController();

  // form key validator state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // active payment selection (COD | PORTPOS)
  final RxString selectedPaymentMethod = 'COD'.obs;

  // loading state driven via isLoading — disables place-order button while request runs
  final RxBool isLoading = false.obs;

  late final CartController _cartController;
  final NetworkService _networkService = NetworkService.instance;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
  }

  // ─── checkout submission ─────────────────────────────────────────────────────

  /// validate form, build payload, call /order/checkout, then route based on
  /// paymentMethod (COD → orders screen, PORTPOS → in-app webview → orders screen)
  Future<void> submitCheckout() async {
    // validate billing form before proceeding
    if (!formKey.currentState!.validate()) return;

    if (_cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Your cart is empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // build items list from current cart contents using the sku from productSnapshot
    final List<Map<String, dynamic>> items = _cartController.cartItems
        .map((item) => {
              'sku': item.productSnapshot?.sku ?? '',
              'quantity': item.quantity,
            })
        .toList();

    // build request body per api spec
    final Map<String, dynamic> body = {
      'items': items,
      'customer': {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'note': noteController.text.trim(),
      },
      'paymentMethod': selectedPaymentMethod.value,
    };

    // append coupon code only if the user entered one
    final String coupon = couponController.text.trim();
    if (coupon.isNotEmpty) {
      body['couponCode'] = coupon;
    }

    try {
      final result = await _networkService.post('/order/checkout', data: body);

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final dynamic data = responseData['data'];

        if (selectedPaymentMethod.value == 'COD') {
          // cod — order placed, clear cart and navigate to orders screen
          await _handleCodSuccess(data as Map<String, dynamic>?);
        } else {
          // portpos — open payment webview with the returned paymentUrl
          await _handlePortPosPayment(data as Map<String, dynamic>?);
        }
      } else {
        // api returned an error response
        final String errorMsg =
            result.message ?? 'Failed to place order. Please try again.';
        Get.snackbar(
          'Order Failed',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      debugPrint('CheckoutController: submitCheckout error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─── payment method handlers ─────────────────────────────────────────────────

  /// handle successful cod order — show success snackbar, clear cart, go to orders
  Future<void> _handleCodSuccess(Map<String, dynamic>? data) async {
    final String orderId = data?['orderId'] as String? ?? '';

    Get.snackbar(
      'Order Placed! 🎉',
      orderId.isNotEmpty
          ? 'Your order $orderId has been placed successfully.'
          : 'Your order has been placed successfully.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );

    // clear cart after a successful order
    _cartController.clearCartList();

    // navigate back to the base screen then switch to orders tab
    _navigateToOrdersScreen();
  }

  /// open portpos payment webview; on result navigate to orders or show failure dialog
  Future<void> _handlePortPosPayment(Map<String, dynamic>? data) async {
    final String? paymentUrl = data?['paymentUrl'] as String?;
    final String? orderId = data?['orderId'] as String?;

    if (paymentUrl == null || paymentUrl.isEmpty) {
      Get.snackbar(
        'Payment Error',
        'Could not retrieve payment URL. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // push the in-app webview and await the boolean result
    final bool? paymentSuccess = await Get.to<bool>(
      () => PaymentWebviewScreen(
        url: paymentUrl,
        successUrl: _kPortPosSuccessUrl,
        screenTitle: 'Secure Payment',
      ),
    );

    if (paymentSuccess == true) {
      // payment confirmed via success redirect url
      Get.snackbar(
        'Payment Successful! 🎉',
        orderId != null
            ? 'Your order $orderId has been placed successfully.'
            : 'Your order has been placed successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // clear cart since order is now confirmed
      _cartController.clearCartList();

      // go to orders screen
      _navigateToOrdersScreen();
    } else {
      // payment failed or was cancelled — show dialog with options
      _showPaymentFailedDialog(orderId);
    }
  }

  /// show a dialog on payment failure giving user options to retry or go to orders
  void _showPaymentFailedDialog(String? orderId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Payment Failed'),
        content: Text(
          orderId != null
              ? 'Payment for order $orderId was not completed. '
                  'You can retry the payment or go to your orders to try again later.'
              : 'Your payment was not completed. Please try again.',
        ),
        actions: [
          // go back to checkout to retry placing the order
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Retry'),
          ),
          // navigate to orders screen (order may exist as pending)
          TextButton(
            onPressed: () {
              Get.back();
              _navigateToOrdersScreen();
            },
            child: const Text('Go to Orders'),
          ),
        ],
      ),
    );
  }

  // ─── navigation helper ───────────────────────────────────────────────────────

  /// pop back to the base screen and switch the bottom nav to the orders tab
  void _navigateToOrdersScreen() {
    // pop all routes until the base screen is on top
    Get.until((route) => route.isFirst);

    // switch bottom nav tab to orders (index 3)
    if (Get.isRegistered<BaseController>()) {
      Get.find<BaseController>().goToOrderScreen();
    }
  }

  // ─── dispose ─────────────────────────────────────────────────────────────────

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    noteController.dispose();
    couponController.dispose();
    super.onClose();
  }
}
