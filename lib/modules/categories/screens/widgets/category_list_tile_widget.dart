import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/home_model.dart';

/// expandable list tile for a single category with its sub-categories
class CategoryListTileWidget extends StatelessWidget {
  final CategoryModel category;

  const CategoryListTileWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceSM.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
        border: Border.all(color: AppColors.greyBorder, width: 0.8),
      ),
      child: Theme(
        // remove default divider line from ExpansionTile
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLG.w,
            vertical: AppDimensions.spaceXS.h,
          ),
          leading: GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.subCategoryProducts,
                arguments: {
                  'slug': category.slug,
                  'name': category.name,
                  'isMainCategory': true,
                },
              );
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                _getCategoryIcon(category.slug),
                color: AppColors.primary,
                size: AppDimensions.iconMD,
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.subCategoryProducts,
                arguments: {
                  'slug': category.slug,
                  'name': category.name,
                  'isMainCategory': true,
                },
              );
            },
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: AppDimensions.fontMD,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
          // show sub-category count as subtitle when available
          subtitle: category.subCategories.isNotEmpty
              ? Text(
                  '${category.subCategories.length} sub-categories',
                  style: const TextStyle(
                    fontSize: AppDimensions.fontXS,
                    color: AppColors.grey,
                  ),
                )
              : null,
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.grey,
          // sub-category rows under expanded category
          children: category.subCategories
              .map(
                (sub) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.only(
                    left: AppDimensions.spaceXXL.w + AppDimensions.spaceLG.w,
                    right: AppDimensions.spaceLG.w,
                  ),
                  leading: const Icon(
                    Icons.arrow_right,
                    color: AppColors.primary,
                    size: AppDimensions.iconSM,
                  ),
                  title: Text(
                    sub.name,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSM,
                      color: AppColors.greyDark,
                    ),
                  ),
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.subCategoryProducts,
                      arguments: {'slug': sub.slug, 'name': sub.name},
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// maps category slug keywords to appropriate material icon
  IconData _getCategoryIcon(String slug) {
    if (slug.contains('fan') || slug.contains('cooler')) return Icons.air;
    if (slug.contains('cleaning') || slug.contains('vacuum')) {
      return Icons.cleaning_services;
    }
    if (slug.contains('packaging') || slug.contains('sealer')) {
      return Icons.inventory_2;
    }
    if (slug.contains('construction') || slug.contains('concrete')) {
      return Icons.construction;
    }
    if (slug.contains('electrical') || slug.contains('electric')) {
      return Icons.electrical_services;
    }
    if (slug.contains('welding') || slug.contains('weld')) {
      return Icons.hardware;
    }
    if (slug.contains('hand-tool') || slug.contains('handtool')) {
      return Icons.handyman;
    }
    if (slug.contains('power-tool') || slug.contains('powertool')) {
      return Icons.build;
    }
    if (slug.contains('safety')) return Icons.security;
    if (slug.contains('plumbing') || slug.contains('pipe')) {
      return Icons.plumbing;
    }
    if (slug.contains('generator')) return Icons.electric_bolt;
    if (slug.contains('pump')) return Icons.water;
    if (slug.contains('painting') || slug.contains('paint')) {
      return Icons.format_paint;
    }
    if (slug.contains('measurement') || slug.contains('scale')) {
      return Icons.straighten;
    }
    return Icons.category_outlined;
  }
}
