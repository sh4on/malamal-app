import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:project_m/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/home_model.dart';

/// feature promo banner row — 3 horizontally scrollable promo tiles below carousel
class FeatureBannersWidget extends StatelessWidget {
  final List<FeatureModel> features;

  const FeatureBannersWidget({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: AppDimensions.featureBannerHeight.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () => Get.toNamed(
              AppRoutes.productDetails,
              arguments: {"slug": feature.clickUrl.substring(9)},
            ),
            child: Container(
              // each feature tile is 40% of screen width with right margin
              width: MediaQuery.of(context).size.width * 0.55,
              margin: EdgeInsets.only(right: AppDimensions.spaceSM.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
                color: AppColors.greyLight,
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: feature.image,
                memCacheHeight: 200,
                memCacheWidth: 400,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.shimmer),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.greyLight,
                  child: const Icon(Icons.broken_image, color: AppColors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
