import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';

/// forgot password recovery OTP verification form layout
class ForgotPasswordOtpForm extends StatelessWidget {
  final AuthController controller;

  const ForgotPasswordOtpForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // build layout container for recovery OTP inputs and resends
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recovery OTP',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        const Text(
          'Enter the password recovery OTP code sent to your email address.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.greyDark,
            height: 1.4,
          ),
        ),
        SizedBox(height: 20.h),
        const Text(
          'Verification Code (OTP) *',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.greyDark,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller.otpController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            hintText: 'e.g. 339464',
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
                  : controller.verifyForgotPasswordOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : const Text(
                      'VERIFY OTP',
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
          child: Obx(
            () => TextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.resendForgotPasswordOtp,
              child: const Text(
                'Resend OTP Code',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
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
