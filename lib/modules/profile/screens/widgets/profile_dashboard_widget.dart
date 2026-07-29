import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../base/controllers/base_controller.dart';
import '../../../../routes/app_routes.dart';
import 'profile_menu_item_widget.dart';


/// logged-in user dashboard panel with profile header and options menu
class ProfileDashboardWidget extends StatelessWidget {
  final String displayName;
  final String displayEmail;
  final String displayPhone;
  final VoidCallback onLogout;

  const ProfileDashboardWidget({
    super.key,
    required this.displayName,
    required this.displayEmail,
    required this.displayPhone,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // profile header banner card
          Container(
            color: AppColors.white,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceXL.w,
              vertical: AppDimensions.spaceXXL.h,
            ),
            child: Column(
              children: [
                // avatar circle with first letter of name
                CircleAvatar(
                  radius: 36.r,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: AppDimensions.space32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.spaceMD.h),
                // user display name
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontXL,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                if (displayEmail.isNotEmpty) ...[
                  SizedBox(height: AppDimensions.spaceXXS.h),
                  Text(
                    displayEmail,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSM,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spaceMD.h),

          // profile options menu card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
                border: Border.all(color: AppColors.greyBorder, width: 0.8),
              ),
              child: Column(
                children: [
                  ProfileMenuItemWidget(
                    icon: Icons.shopping_bag_outlined,
                    title: AppStrings.myOrdersMenu,
                    onTap: () {
                      Get.find<BaseController>().goToOrderScreen();
                    },
                  ),
                  Divider(height: 1, indent: AppDimensions.spaceLG.w + 52.w),
                  ProfileMenuItemWidget(
                    icon: Icons.person_outline,
                    title: AppStrings.accountInformation,
                    onTap: () {
                      Get.toNamed(AppRoutes.accountInfo);
                    },
                  ),
                  Divider(height: 1, indent: AppDimensions.spaceLG.w + 52.w),
                  ProfileMenuItemWidget(
                    icon: Icons.lock_outline,
                    title: AppStrings.changePassword,
                    onTap: () {
                      Get.toNamed(AppRoutes.changePassword);
                    },
                  ),
                  Divider(height: 1, indent: AppDimensions.spaceLG.w + 52.w),
                  ProfileMenuItemWidget(
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spaceXXL.h),
        ],
      ),
    );
  }
}
