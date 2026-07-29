import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/mixins/validation_mixin.dart';

/// forgot password recovery form layout section
class ForgotPasswordForm extends StatelessWidget with ValidationMixin {
  final AuthController controller;

  const ForgotPasswordForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lost Password',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        const Text(
          'Lost your password? Please enter your email address. You will receive a link to create a new password via email.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.greyDark,
            height: 1.4,
          ),
        ),
        SizedBox(height: 20.h),
        const Text(
          'Email *',
          style: TextStyle(fontSize: 14, color: AppColors.greyDark),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller.emailController,
          validator: validateEmail,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.submitForgotPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: GestureDetector(
            onTap: () => controller.switchForm(0),
            child: const Text(
              'Back to Login',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
