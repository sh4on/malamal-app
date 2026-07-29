import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/product_details_controller.dart';
import 'package:project_m/modules/base/controllers/base_controller.dart';
import 'package:project_m/modules/cart/controllers/cart_controller.dart';

/// sticky bottom bar widget with add to cart and buy now buttons
class ProductBottomBarWidget extends StatelessWidget {
  const ProductBottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG.w,
        vertical: AppDimensions.spaceMD.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // add to cart button
            Expanded(
              child: SizedBox(
                height: AppDimensions.buttonHeightLG.h,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // returns false if user is not logged in (redirected to login)
                    final bool added = controller.addToCart();

                    // only show confirmation snackbar when item was actually added
                    if (added) {
                      Get.snackbar(
                        AppStrings.addedToCart,
                        AppStrings.addedToCartMessage,
                        backgroundColor: AppColors.primary,
                        colorText: AppColors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(AppDimensions.spaceMD.w),
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: AppDimensions.iconMD,
                  ),
                  label: const Text(
                    AppStrings.addToCart,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSM,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.spaceMD.w),

            // buy now button
            Expanded(
              child: SizedBox(
                height: AppDimensions.buttonHeightLG.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final product = controller.product.value;
                    if (product == null) return;

                    final cartController = Get.put(CartController());
                    final baseController = Get.find<BaseController>();

                    // use isInCart helper instead of manual loop check
                    if (!cartController.isInCart(product.id)) {
                      controller.addToCart();
                    }

                    Get.until((route) => route.settings.name == AppRoutes.base || route.isFirst);
                    baseController.goToCartScreen();
                  },
                  icon: const Icon(
                    Icons.flash_on_rounded,
                    size: AppDimensions.iconMD,
                  ),
                  label: const Text(
                    AppStrings.buyNow,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSM,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
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
