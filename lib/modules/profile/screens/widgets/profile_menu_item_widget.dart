import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// a single row item in the profile options menu list
class ProfileMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback onTap;

  const ProfileMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.titleColor,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG.w,
        vertical: AppDimensions.spaceXXS.h,
      ),
      leading: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (iconColor ?? AppColors.secondary).withOpacity(0.08),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.secondary,
          size: AppDimensions.iconMD,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppDimensions.fontMD,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.black,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.grey,
        size: AppDimensions.iconMD,
      ),
      onTap: onTap,
    );
  }
}
