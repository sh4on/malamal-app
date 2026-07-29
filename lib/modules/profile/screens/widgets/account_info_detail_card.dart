import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// a single information row displaying a label, value, and icon
class AccountInfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AccountInfoRowWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG.w,
        vertical: AppDimensions.spaceMD.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icon container with soft accent background
          Container(
            padding: EdgeInsets.all(AppDimensions.spaceSM.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.08),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppDimensions.iconMD,
            ),
          ),
          SizedBox(width: AppDimensions.spaceMD.w),
          // label and value texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSM,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXXS.h),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontMD,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// account details card container grouping all user attributes
class AccountInfoDetailCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String role;

  const AccountInfoDetailCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
        border: Border.all(
          color: AppColors.greyBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          // name field row
          AccountInfoRowWidget(
            icon: Icons.person_outline,
            label: 'Full Name',
            value: name.isNotEmpty ? name : 'N/A',
          ),
          Divider(height: 1, indent: AppDimensions.spaceLG.w + 36.w),

          // email field row
          AccountInfoRowWidget(
            icon: Icons.email_outlined,
            label: 'Email Address',
            value: email.isNotEmpty ? email : 'N/A',
          ),
          Divider(height: 1, indent: AppDimensions.spaceLG.w + 36.w),

          // phone field row
          AccountInfoRowWidget(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: phone.isNotEmpty ? phone : 'N/A',
          ),
          Divider(height: 1, indent: AppDimensions.spaceLG.w + 36.w),

          // date of birth row
          AccountInfoRowWidget(
            icon: Icons.cake_outlined,
            label: 'Date of Birth',
            value: dob.isNotEmpty ? dob : 'N/A',
          ),
          Divider(height: 1, indent: AppDimensions.spaceLG.w + 36.w),

          // role/account type row
          AccountInfoRowWidget(
            icon: Icons.badge_outlined,
            label: 'Account Role',
            value: role.isNotEmpty ? role : 'USER',
          ),
        ],
      ),
    );
  }
}
