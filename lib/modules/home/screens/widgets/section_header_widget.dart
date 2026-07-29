import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// reusable section header row with title on left and "View All" link on right
class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.showViewAll = true,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left: section title with left indicator bar accent
          Row(
            children: [
              // orange accent bar to the left of title
              Container(
                width: 3.w,
                height: AppDimensions.spaceXL.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusRound.r,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spaceSM.w),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppDimensions.fontLG,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          // right: "View All" link
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllTap,
              child: const Text(
                AppStrings.viewAll,
                style: TextStyle(
                  fontSize: AppDimensions.fontSM,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
