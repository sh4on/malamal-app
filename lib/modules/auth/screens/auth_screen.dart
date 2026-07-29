import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_tab_switcher_widget.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_form.dart';
import 'widgets/forgot_password_form.dart';
import 'widgets/otp_form.dart';
import 'widgets/forgot_password_otp_form.dart';
import 'widgets/reset_password_form.dart';
import '../../../core/constants/app_colors.dart';

/// auth screen — scaffold shell with tab switcher and dynamic form card
class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize binding dependency controller manually if route didn't inject it
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // login/register tab switcher — auth_tab_switcher_widget.dart
            AuthTabSwitcherWidget(controller: controller),

            // active selected form layout card
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Card(
                color: AppColors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Obx(() {
                    // switch form based on active index from controller
                    switch (controller.activeForm.value) {
                      case 0:
                        return LoginForm(controller: controller);
                      case 1:
                        return SignupForm(controller: controller);
                      case 2:
                        return ForgotPasswordForm(controller: controller);
                      case 3:
                        return OtpForm(controller: controller);
                      case 4:
                        return ForgotPasswordOtpForm(controller: controller);
                      case 5:
                        return ResetPasswordForm(controller: controller);
                      default:
                        return LoginForm(controller: controller);
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
