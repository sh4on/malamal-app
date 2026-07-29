import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'widgets/cart_body_widget.dart';
import '../../../shared/common_widgets/loading_state_widget.dart';
import '../../../shared/common_widgets/empty_state_widget.dart';
import '../../../shared/common_widgets/error_state_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// shopping cart screen — scaffold shell delegating content to widget files
class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // manually inject controller if not registered
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text(
          AppStrings.shoppingCart,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        actions: [
          // clear all cart items button
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppColors.primary),
            onPressed: () => controller.clearCartList(),
          ),
        ],
      ),
      // pull-to-refresh wraps the entire body so user can refresh in any state
      body: RefreshIndicator(
        onRefresh: controller.fetchCart,
        color: AppColors.primary,
        child: Obx(() {
          final statusVal = controller.status.value;

          // loading state
          if (statusVal.isLoading) {
            return const LoadingStateWidget(
              loadingMessage: 'Fetching your cart items...',
            );
          }

          // empty cart state — wrapped in SingleChildScrollView so pull-to-refresh
          // gesture is still recognised even when content doesn't fill the screen
          if (statusVal.isEmpty) {
            return const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 500,
                child: EmptyStateWidget(
                  message: 'Your cart is currently empty!',
                  icon: Icons.shopping_cart_outlined,
                ),
              ),
            );
          }

          // error state
          if (statusVal.isError) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 500,
                child: ErrorStateWidget(
                  errorMessage: statusVal.errorMessage ?? 'Failed to load cart',
                  onRetry: controller.fetchCart,
                ),
              ),
            );
          }

          // success — cart list + order summary extracted to cart_body_widget.dart
          return const CartBodyWidget();
        }),
      ),
    );
  }
}
