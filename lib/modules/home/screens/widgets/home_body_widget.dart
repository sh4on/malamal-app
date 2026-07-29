import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/models/home_model.dart';
import '../../../base/controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import 'carousel_slider_widget.dart';
import 'category_card_widget.dart';
import 'feature_banners_widget.dart';
import 'brands_section_widget.dart';
import 'section_header_widget.dart';
import 'home_product_grid_widget.dart';

/// scrollable home body content — carousel, features, categories, brands, products
class HomeBodyWidget extends GetView<HomeController> {
  const HomeBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // pull-to-refresh wraps the entire scrollable content
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: controller.fetchHomeData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppDimensions.spaceSM.h),

            // hero banner carousel from api slides
            CarouselSliderWidget(slides: controller.slides),
            SizedBox(height: AppDimensions.spaceLG.h),

            // feature promo banners horizontal row (only if data exists)
            if (controller.features.isNotEmpty) ...[
              FeatureBannersWidget(features: controller.features),
              SizedBox(height: AppDimensions.spaceLG.h),
            ],

            // shop by category section
            SectionHeaderWidget(
              title: AppStrings.shopByCategory,
              onViewAllTap: () {
                Get.find<BaseController>().changeIndex(1);
              },
            ),
            SizedBox(height: AppDimensions.spaceMD.h),
            _HomeCategoryListWidget(),
            SizedBox(height: AppDimensions.spaceLG.h),

            // top brands section
            const SectionHeaderWidget(
              title: AppStrings.topBrands,
              showViewAll: false,
            ),
            SizedBox(height: AppDimensions.spaceMD.h),
            BrandsSectionWidget(brands: controller.brands),
            SizedBox(height: AppDimensions.spaceLG.h),

            // featured products grid section
            const SectionHeaderWidget(
              title: AppStrings.featuredProducts,
              showViewAll: false,
            ),
            SizedBox(height: AppDimensions.spaceMD.h),
            HomeProductGridWidget(products: controller.featuredProducts),
            SizedBox(height: AppDimensions.spaceLG.h),

            // latest products grid section
            const SectionHeaderWidget(
              title: AppStrings.latestProducts,
              showViewAll: false,
            ),
            SizedBox(height: AppDimensions.spaceMD.h),
            HomeProductGridWidget(products: controller.latestProducts),

            SizedBox(height: AppDimensions.spaceXXL.h),
          ],
        ),
      ),
    );
  }
}

/// horizontal scrollable categories list for the home screen
class _HomeCategoryListWidget extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.categoryCardHeight.h,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: AppDimensions.spaceLG.w),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final CategoryModel category = controller.categories[index];
            return CategoryCardWidget(
              category: category,
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
            );
          },
        ),
      ),
    );
  }
}

