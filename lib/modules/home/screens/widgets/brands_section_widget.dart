import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/home_model.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

/// top brands horizontal scroll section displaying brand logos
class BrandsSectionWidget extends StatelessWidget {
  final List<BrandModel> brands;

  const BrandsSectionWidget({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      // fixed height for the brand card row
      height: AppDimensions.brandCardHeight.h + AppDimensions.spaceXL.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.brand,
                arguments: {
                  'brand_id': brand.id.toString(),
                  'brand_name': brand.name,
                },
              );
            },
            child: Container(
              width: AppDimensions.brandCardWidth.w,
              margin: EdgeInsets.only(right: AppDimensions.spaceSM.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
                border: Border.all(color: AppColors.greyBorder, width: 0.8),
              ),
              padding: EdgeInsets.all(AppDimensions.spaceXS.w),
              child: _buildBrandLogo(brand),
            ),
          );
        },
      ),
    );
  }

  /// build brand logo image or fallback text
  Widget _buildBrandLogo(BrandModel brand) {
    debugPrint('xxx ${brand.name}');

    if (brand.image != null && brand.image!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: brand.image!,
        memCacheHeight: 128,
        memCacheWidth: 180,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackText(brand.name),
      );
    }

    return _buildFallbackText(brand.name);
  }

  /// fallback text label when brand has no logo image
  Widget _buildFallbackText(String name) {
    return Center(
      child: Text(
        name,
        style: const TextStyle(
          fontSize: AppDimensions.fontXS,
          fontWeight: FontWeight.w600,
          color: AppColors.greyDark,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
