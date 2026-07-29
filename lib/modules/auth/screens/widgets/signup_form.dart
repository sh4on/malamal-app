import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/mixins/validation_mixin.dart';

/// registration form layout section
class SignupForm extends StatelessWidget with ValidationMixin {
  final AuthController controller;

  const SignupForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Register',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(height: 16.h),
          const Text(
            'Full Name *',
            style: TextStyle(fontSize: 14, color: AppColors.greyDark),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller.nameController,
            validator: (value) =>
                value == null || value.isEmpty ? 'Name is required' : null,
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
          SizedBox(height: 16.h),
          const Text(
            'Email address *',
            style: TextStyle(fontSize: 14, color: AppColors.greyDark),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller.emailController,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
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
          SizedBox(height: 16.h),
          const Text(
            'Password *',
            style: TextStyle(fontSize: 14, color: AppColors.greyDark),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller.passwordController,
            validator: validatePassword,
            obscureText: true,
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
          SizedBox(height: 16.h),
          const Text(
            'Your personal data will be used to support your experience throughout this website, to manage access to your account, and for other purposes described in our privacy policy.',
            style: TextStyle(fontSize: 12, color: AppColors.grey, height: 1.4),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submitRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
