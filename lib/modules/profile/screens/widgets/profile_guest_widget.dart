import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// guest user panel displayed when user is not logged in
class ProfileGuestWidget extends StatelessWidget {
  const ProfileGuestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceXXL.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // guest avatar circle icon
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceXL.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
              child: Icon(
                Icons.account_circle_outlined,
                size: 72.w,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.spaceXXL.h),
            const Text(
              AppStrings.signInPrompt,
              style: TextStyle(
                fontSize: AppDimensions.fontXL,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spaceSM.h),
            const Text(
              AppStrings.signInSubtitle,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: AppDimensions.fontMD,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.space32.h),
            // login/register call to action button
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
