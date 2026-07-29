import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../controllers/search_controller.dart' as app_search;

/// search input field row with embedded submit button
class SearchInputWidget extends StatelessWidget {
  final app_search.SearchController controller;

  const SearchInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // search input text field container
        Expanded(
          child: Container(
            height: AppDimensions.searchBarHeight.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
              border: Border.all(color: AppColors.greyBorder, width: 0.8),
            ),
            child: TextField(
              controller: controller.searchTextController,
              onChanged: controller.updateQuery,
              onSubmitted: controller.submitSearch,
              decoration: InputDecoration(
                hintText: 'Search products, categories, brands...',
                hintStyle: const TextStyle(color: AppColors.grey, fontSize: AppDimensions.fontMD),
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                // clear button overlay shown only when query text is present
                suffixIcon: Obx(
                  () => controller.currentQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.grey, size: AppDimensions.iconSM),
                          onPressed: () {
                            controller.searchTextController.clear();
                            controller.updateQuery('');
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
        ),
        SizedBox(width: AppDimensions.spaceSM.w),
        // submit search button
        SizedBox(
          height: AppDimensions.searchBarHeight.h,
          child: ElevatedButton(
            onPressed: () {
              controller.submitSearch(controller.searchTextController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
              elevation: 0,
            ),
            child: const Text(
              'SEARCH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontMD,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
