import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/common_widgets/error_state_widget.dart';
import '../../../shared/common_widgets/loading_state_widget.dart';
import '../controllers/product_details_controller.dart';
import 'widgets/product_bottom_bar_widget.dart';
import 'widgets/product_delivery_options_widget.dart';
import 'widgets/product_description_widget.dart';
import 'widgets/product_features_widget.dart';
import 'widgets/product_image_carousel_widget.dart';
import 'widgets/product_info_header_widget.dart';

/// main product details screen composing all extracted section widgets
class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // app bar with back button and product title
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
            size: AppDimensions.iconMD,
          ),
        ),
        title: Obx(
          () => Text(
            controller.product.value?.title ?? AppStrings.productDetails,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
        centerTitle: false,
      ),
      // body with reactive state switching
      body: Obx(() {
        // loading state
        if (controller.status.value.isLoading) {
          return const LoadingStateWidget(
            loadingMessage: 'Loading product details...',
          );
        }

        // error state
        if (controller.status.value.isError) {
          return ErrorStateWidget(
            errorMessage:
                controller.status.value.errorMessage ?? AppStrings.errorRetry,
            onRetry: controller.getProductDetails,
          );
        }

        // success state — product data available
        final product = controller.product.value;
        if (product == null) {
          return ErrorStateWidget(
            errorMessage: 'Product not found',
            onRetry: controller.getProductDetails,
          );
        }

        return Column(
          children: [
            // scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image carousel section
                    ProductImageCarouselWidget(
                      images: product.images,
                      badge: product.badge,
                      discountPercent: product.discountPercent,
                      youtubeVideoId: product.youtubeVideoId,
                    ),

                    // thin divider line
                    const Divider(height: 1, color: AppColors.divider),

                    // product info header (brand, title, sku, price, rating)
                    ProductInfoHeaderWidget(product: product),

                    // thin divider line
                    Divider(
                      height: 1,
                      color: AppColors.divider,
                      indent: AppDimensions.spaceLG.w,
                      endIndent: AppDimensions.spaceLG.w,
                    ),
                    SizedBox(height: AppDimensions.spaceLG.h),

                    // // quantity selector
                    // ProductQuantitySelectorWidget(
                    //   sellingUnit: product.sellingUnit,
                    // ),
                    // SizedBox(height: AppDimensions.spaceXL.h),

                    // thin divider line
                    // Divider(
                    //   height: 1,
                    //   color: AppColors.divider,
                    //   indent: AppDimensions.spaceLG.w,
                    //   endIndent: AppDimensions.spaceLG.w,
                    // ),
                    // SizedBox(height: AppDimensions.spaceXL.h),

                    // features / specifications section
                    ProductFeaturesWidget(featuresHtml: product.features),
                    SizedBox(height: AppDimensions.spaceXXL.h),

                    // delivery options card
                    const ProductDeliveryOptionsWidget(),

                    SizedBox(height: AppDimensions.space32.h),

                    // description section with expand/collapse
                    ProductDescriptionWidget(
                      descriptionHtml: product.description,
                    ),

                    // bottom padding to avoid overlap with sticky bar
                    SizedBox(height: AppDimensions.space48.h),
                  ],
                ),
              ),
            ),

            // sticky bottom bar with add to cart / buy now buttons
            const ProductBottomBarWidget(),
          ],
        );
      }),
    );
  }
}
