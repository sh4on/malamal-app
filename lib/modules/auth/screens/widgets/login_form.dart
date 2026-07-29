import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/mixins/validation_mixin.dart';

/// login form layout section
class LoginForm extends StatelessWidget with ValidationMixin {
  final AuthController controller;

  const LoginForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(height: 16.h),
          const Text(
            'Username or email address *',
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
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (val) {
                    controller.rememberMe.value = val ?? false;
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              const Text(
                'Remember me',
                style: TextStyle(fontSize: 14, color: AppColors.black),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submitLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text(
                        'LOG IN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () => controller.switchForm(2),
            child: const Text(
              'Lost your password?',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
