import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/change_password_controller.dart';
import 'widgets/change_password_form.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// change password settings screen interface
class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text(
          AppStrings.changePassword,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spaceLG.w),
          child: Column(
            children: [
              SizedBox(height: AppDimensions.spaceMD.h),
              // card layout wrapping the change password input fields
              Card(
                color: AppColors.white,
                elevation: AppDimensions.elevationSM,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
                  side: const BorderSide(color: AppColors.greyBorder, width: 0.8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.spaceXL.w),
                  child: ChangePasswordForm(controller: controller),
                ),
              ),
              SizedBox(height: AppDimensions.spaceXXL.h),
            ],
          ),
        ),
      ),
    );
  }
}
