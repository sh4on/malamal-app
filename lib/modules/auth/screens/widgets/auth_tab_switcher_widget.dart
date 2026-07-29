import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/auth_controller.dart';

/// login/register tab switcher header bar shown above auth forms
class AuthTabSwitcherWidget extends StatelessWidget {
  final AuthController controller;

  const AuthTabSwitcherWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int active = controller.activeForm.value;

      // hide tabs when on forgot password (2), signup otp verification (3), recovery otp verification (4), or reset password (5) screens
      if (active == 2 || active == 3 || active == 4 || active == 5) {
        return const SizedBox.shrink();
      }

      return Container(
        color: AppColors.white,
        child: Row(
          children: [
            // login tab
            _AuthTab(
              label: 'LOGIN',
              isActive: active == 0,
              onTap: () => controller.switchForm(0),
            ),
            // register tab
            _AuthTab(
              label: 'REGISTER',
              isActive: active == 1,
              onTap: () => controller.switchForm(1),
            ),
          ],
        ),
      );
    });
  }
}

/// single tab item with bottom border indicator for active state
class _AuthTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _AuthTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                // orange underline for active tab, transparent for inactive
                color: isActive ? AppColors.primary : AppColors.transparent,
                width: 3.h,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isActive ? AppColors.primary : AppColors.greyDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
