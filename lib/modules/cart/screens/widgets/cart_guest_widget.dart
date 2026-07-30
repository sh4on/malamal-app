import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// guest sign-in prompt shown on cart screen when user is not logged in
class CartGuestWidget extends StatelessWidget {
  const CartGuestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceXXL.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // shopping bag icon circle
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceXL.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64.w,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.spaceXXL.h),
            // title
            const Text(
              AppStrings.shoppingCart,
              style: TextStyle(
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: AppDimensions.spaceSM.h),
            // subtitle
            const Text(
              'Sign in to view your cart and continue shopping.',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: AppDimensions.fontMD,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.space32.h),
            // login/register cta button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightLG.h,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/auth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
                  ),
                ),
                child: const Text(
                  AppStrings.loginRegister,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontMD,
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
