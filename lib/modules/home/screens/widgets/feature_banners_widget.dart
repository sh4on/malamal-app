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
            onTap: () {
              debugPrint('feature.clickUrl: ${feature.clickUrl}');

              // parse the clickUrl as a URI to safely extract path segments
              // this handles both full URLs (https://malamal.com.bd/product/...)
              // and relative paths (product/...) without fragile substring offsets
              final Uri uri = Uri.parse(feature.clickUrl);
              final List<String> segments = uri.pathSegments;

              if (segments.isEmpty) return;

              // first path segment indicates the type: 'category' or 'product'
              final String type = segments.first;

              if (type == 'category') {
                // url shape: /category/{parentSlug}/{subSlug}
                // target slug is always the last segment
                final String targetSlug = segments.last;

                // isMain = true only when there is no sub-category segment
                // e.g. /category/welding-cutting → isMain (2 segments incl. 'category')
                // e.g. /category/welding-cutting/welding-machine → sub-category (3 segments)
                final bool isMain = segments.length == 2;

                // format slug to title case for the screen title
                final String name = targetSlug
                    .split('-')
                    .map(
                      (word) => word.isNotEmpty
                          ? '${word[0].toUpperCase()}${word.substring(1)}'
                          : '',
                    )
                    .join(' ');

                debugPrint(
                  '[FeatureBanner] category slug: $targetSlug (isMain: $isMain)',
                );

                Get.toNamed(
                  AppRoutes.subCategoryProducts,
                  arguments: {
                    'slug': targetSlug,
                    'name': name,
                    'isMainCategory': isMain,
                  },
                );
              } else {
                // product link: slug is always the last path segment
                final String productSlug = segments.last;

                debugPrint('[FeatureBanner] product slug: $productSlug');

                Get.toNamed(
                  AppRoutes.productDetails,
                  arguments: {'slug': productSlug},
                );
              }
            },
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
