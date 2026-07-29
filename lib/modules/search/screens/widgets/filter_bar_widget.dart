import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

/// search directory filter statistics details bar
class FilterBarWidget extends StatelessWidget {
  final String statsText;
  final VoidCallback onFilterTap;

  const FilterBarWidget({
    super.key,
    required this.statsText,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // filter button
              OutlinedButton.icon(
                onPressed: onFilterTap,
                icon: const Icon(Icons.filter_list, size: 18),
                label: const Text('Filter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.black,
                  side: BorderSide(color: AppColors.grey.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              // sort dropdown placeholder
              Row(
                children: [
                  const Text(
                    'Sort:',
                    style: TextStyle(color: AppColors.grey, fontSize: 13),
                  ),
                  SizedBox(width: 4.w),
                  const Text(
                    'Default sorting',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.black,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: AppColors.black),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // search result stats text
          Text(
            statsText,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.greyDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
