import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/change_password_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/mixins/validation_mixin.dart';

/// custom standalone form widget for changing password
class ChangePasswordForm extends StatelessWidget with ValidationMixin {
  final ChangePasswordController controller;

  const ChangePasswordForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // old password label and field
          const Text(
            'Old Password *',
            style: TextStyle(
              fontSize: AppDimensions.fontMD,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimensions.spaceXS.h),
          Obx(
            () => TextFormField(
              controller: controller.oldPasswordController,
              validator: validatePassword,
              obscureText: controller.isOldPasswordObscure.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: 'Enter old password',
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppDimensions.fontMD,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isOldPasswordObscure.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    controller.isOldPasswordObscure.value =
                        !controller.isOldPasswordObscure.value;
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
                  borderSide: const BorderSide(color: AppColors.greyBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD.w,
                  vertical: AppDimensions.spaceMD.h,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spaceLG.h),

          // new password label and field
          const Text(
            'New Password *',
            style: TextStyle(
              fontSize: AppDimensions.fontMD,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimensions.spaceXS.h),
          Obx(
            () => TextFormField(
              controller: controller.newPasswordController,
              validator: validatePassword,
              obscureText: controller.isNewPasswordObscure.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: 'Enter new password',
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppDimensions.fontMD,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isNewPasswordObscure.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    controller.isNewPasswordObscure.value =
                        !controller.isNewPasswordObscure.value;
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
                  borderSide: const BorderSide(color: AppColors.greyBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD.w,
                  vertical: AppDimensions.spaceMD.h,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spaceLG.h),

          // confirm new password label and field
          const Text(
            'Confirm New Password *',
            style: TextStyle(
              fontSize: AppDimensions.fontMD,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimensions.spaceXS.h),
          Obx(
            () => TextFormField(
              controller: controller.confirmPasswordController,
              validator: validatePassword,
              obscureText: controller.isConfirmPasswordObscure.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: 'Confirm new password',
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppDimensions.fontMD,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordObscure.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    controller.isConfirmPasswordObscure.value =
                        !controller.isConfirmPasswordObscure.value;
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
                  borderSide: const BorderSide(color: AppColors.greyBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMD.w,
                  vertical: AppDimensions.spaceMD.h,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spaceXXL.h),

          // submit change password button
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightLG.h,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submitChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
                  ),
                ),
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'CHANGE PASSWORD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.fontMD,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
