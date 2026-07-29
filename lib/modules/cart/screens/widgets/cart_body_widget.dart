import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../controllers/cart_controller.dart';
import 'cart_item_row.dart';

/// cart success body — scrollable item list + bottom order summary with checkout button
class CartBodyWidget extends GetView<CartController> {
  const CartBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // scrollable cart items list section
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];
                return CartItemRow(
                  item: item,
                  onIncrease: () =>
                      controller.increaseQuantity(item.product.id),
                  onDecrease: () =>
                      controller.decreaseQuantity(item.product.id),
                  onRemove: () => controller.removeItem(item.product.id),
                );
              },
            ),
          ),
        ),

        // order summary card pinned at the bottom
        _CartOrderSummaryWidget(),
      ],
    );
  }
}

/// sticky bottom card showing subtotal, shipping, total and checkout button
class _CartOrderSummaryWidget extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // subtotal row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.subtotal,
                    style: TextStyle(color: AppColors.greyDark, fontSize: 14),
                  ),
                  Text(
                    '৳${controller.subtotal.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
                    AppStrings.deliveryCharge,
                    style: TextStyle(color: AppColors.greyDark, fontSize: 14),
                  ),
                  Text(
                    '৳${controller.shipping.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              // total price row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.totalPrice,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    '৳${controller.total.value.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // proceed to checkout button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed('/checkout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    AppStrings.proceedToCheckout,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
