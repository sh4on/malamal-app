import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/checkout_controller.dart';
import '../../../cart/controllers/cart_controller.dart';

/// order total + place order button card at the bottom of checkout
class CheckoutSummaryCardWidget extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutSummaryCardWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Card(
      color: AppColors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // subtotal row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(color: AppColors.greyDark, fontSize: 14),
                ),
                Obx(
                  () => Text(
                    '৳${cartController.subtotal.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // delivery charge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Charge',
                  style: TextStyle(color: AppColors.greyDark, fontSize: 14),
                ),
                Obx(
                  () => Text(
                    '৳${cartController.shipping.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            // show shipping calculation details below the delivery charge row
            Obx(
              () {
                if (cartController.cartItems.isEmpty) return const SizedBox.shrink();
                return Column(
                  children: [
                    SizedBox(height: 4.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Weight: ${cartController.calculateTotalWeight().toStringAsFixed(2)} kg (${cartController.getShippingCalculationDetails()})',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 20),

            // order total price row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Total Price',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Obx(
                  () => Text(
                    '৳${cartController.total.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // place order button with loading state
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.submitCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : const Text(
                          'PLACE ORDER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
