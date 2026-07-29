import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// guest sign-in prompt panel shown when user is not logged in on orders screen
class OrdersGuestWidget extends StatelessWidget {
  const OrdersGuestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceXXL.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // order receipt icon circle
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceXL.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 64.w,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.spaceXXL.h),
            const Text(
              AppStrings.myOrders,
              style: TextStyle(
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: AppDimensions.spaceSM.h),
            const Text(
              'Sign in to view your order history and track your deliveries.',
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
