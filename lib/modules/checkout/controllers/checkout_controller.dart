import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/utils/helper_methods/helper_methods.dart';

/// billing checkout flow data controller
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

  // active payment selection
  final RxString selectedPaymentMethod = 'COD'.obs;

  // loading state
  final RxBool isLoading = false.obs;

  late final CartController _cartController;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
  }

  /// execute checkout order submission via WhatsApp redirection
  Future<void> submitCheckout() async {
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

    // construct WhatsApp message dynamically with grammatically correct and polished English
    final StringBuffer buffer = StringBuffer();
    buffer.writeln("Hi, I would like to buy the following items:\n");
    for (final item in _cartController.cartItems) {
      // prefer productSnapshot title and priceSnapshot for display
      final String itemName =
          item.productSnapshot?.title.isNotEmpty == true
              ? item.productSnapshot!.title
              : item.product.name;
      final double itemPrice =
          item.priceSnapshot > 0 ? item.priceSnapshot : item.product.price;
      buffer.writeln("- $itemName - ৳$itemPrice x ${item.quantity}");
    }
    buffer.writeln("\nPersonal Details:");
    buffer.writeln("- Name: ${nameController.text.trim()}");
    buffer.writeln("- Phone: ${phoneController.text.trim()}");
    if (emailController.text.trim().isNotEmpty) {
      buffer.writeln("- Email: ${emailController.text.trim()}");
    }
    buffer.writeln(
      "- Address: ${addressController.text.trim()}, ${cityController.text.trim()}",
    );
    if (noteController.text.trim().isNotEmpty) {
      buffer.writeln("- Note: ${noteController.text.trim()}");
    }
    buffer.writeln(
      "\nPayment Method: ${selectedPaymentMethod.value != 'COD' ? 'Online Payment' : 'Cash on delivery'}",
    );

    try {
      // open WhatsApp with order details
      await openWhatsApp(buffer.toString());

      Get.snackbar(
        'Success',
        'Order placement triggered via WhatsApp!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // clear cart — fire-and-forget (no await, clearCartList is now void)
      _cartController.clearCartList();

      // normally return back to the app (popping the checkout page, showing empty cart)
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not launch WhatsApp. Please check your setup.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

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
