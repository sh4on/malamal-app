import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/home_model.dart';

/// category chip card — circular icon with label below for shop by category section
class CategoryCardWidget extends StatelessWidget {
  final CategoryModel category;
  final IconData? icon;
  final VoidCallback? onTap;

  const CategoryCardWidget({
    super.key,
    required this.category,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.categoryCardWidth.w,
        margin: EdgeInsets.only(right: AppDimensions.spaceSM.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // circular category icon container
            Container(
              width: AppDimensions.categoryCardWidth.w - 10.w,
              height: AppDimensions.categoryCardWidth.w - 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  icon ?? getRawCategoryIcon(category.slug),
                  color: AppColors.primary,
                  size: AppDimensions.iconLG,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spaceXS.h),
            // category label text centered below the icon
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppDimensions.fontXS,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// map category slug to a relevant material icon for display
  static IconData getRawCategoryIcon(String slug) {
    // map known category slugs to matching icons
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
    if (slug.contains('storage')) return Icons.warehouse;
    // fallback default icon
    return Icons.category_outlined;
  }

  /// get alternative icon that is different from both the current and the previous icon to prevent duplicates
  static IconData getAlternateIcon(IconData current, IconData previous, int index) {
    final List<IconData> alternatePool = [
      Icons.category_outlined,
      Icons.build_outlined,
      Icons.construction_outlined,
      Icons.handyman_outlined,
      Icons.hardware_outlined,
      Icons.grid_view_outlined,
      Icons.settings_outlined,
    ];

    // search the alternate pool for a candidate that is different from both the current 
    // and the previous icon, offset by index to ensure a diverse distribution.
    for (int offset = 0; offset < alternatePool.length; offset++) {
      final candidate = alternatePool[(index + offset) % alternatePool.length];
      if (candidate != previous && candidate != current) {
        return candidate;
      }
    }
    return Icons.category_outlined;
  }
}
