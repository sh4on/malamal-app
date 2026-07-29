import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_m/core/constants/app_dimensions.dart';
import 'package:project_m/modules/cart/controllers/cart_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/common_widgets/product_card_widget.dart';
import '../../../../shared/common_widgets/loading_state_widget.dart';
import '../../../../shared/common_widgets/error_state_widget.dart';
import '../../controllers/search_controller.dart' as app_search;
import 'search_input_widget.dart';

/// search screen body — filter bar, product results grid, and autocomplete overlay
class SearchBodyWidget extends StatelessWidget {
  final app_search.SearchController controller;

  const SearchBodyWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // determine if screen is in its initial unsearched state
      final bool isInitialState =
          !controller.isSearchSubmitted.value &&
          !controller.status.value.isLoading;

      if (isInitialState) {
        // render beautifully centered search input and graphics
        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceXL.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // centered graphic container with primary colored search icon
                Container(
                  padding: EdgeInsets.all(AppDimensions.spaceXL.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.08),
                  ),
                  child: Icon(
                    Icons.search_outlined,
                    size: 72.w,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXXL.h),
                const Text(
                  'Search Malamal Products',
                  style: TextStyle(
                    fontSize: AppDimensions.fontXL,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spaceSM.h),
                const Text(
                  'Find tools, materials, and hardware equipment instantly.',
                  style: TextStyle(
                    fontSize: AppDimensions.fontMD,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spaceXXL.h),
                // search text field and button row
                SearchInputWidget(controller: controller),
              ],
            ),
          ),
        );
      }

      // render search field on top and results grid below
      return Column(
        children: [
          // top search bar input area
          Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLG.w,
              vertical: AppDimensions.spaceMD.h,
            ),
            child: SearchInputWidget(controller: controller),
          ),
          // search result state switcher view
          Expanded(
            child: Builder(
              builder: (context) {
                final statusVal = controller.status.value;

                if (statusVal.isLoading) {
                  return const LoadingStateWidget(
                    loadingMessage: 'Searching...',
                  );
                }

                if (statusVal.isError) {
                  return ErrorStateWidget(
                    errorMessage: statusVal.errorMessage ?? 'Search failed',
                    onRetry: controller.retry,
                  );
                }

                if (statusVal.isEmpty) {
                  return _SearchEmptyStateWidget(
                    query: controller.currentQuery.value,
                  );
                }

                return _SearchResultsGridWidget(controller: controller);
              },
            ),
          ),
        ],
      );
    });
  }
}

/// empty results message shown when no products match the search query
class _SearchEmptyStateWidget extends StatelessWidget {
  final String query;

  const _SearchEmptyStateWidget({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.w, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            "No products found for '$query'",
            style: const TextStyle(color: AppColors.greyDark, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

/// 2-column product grid displaying search results
class _SearchResultsGridWidget extends StatelessWidget {
  final app_search.SearchController controller;

  const _SearchResultsGridWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.all(12.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.52,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
            ),
            itemCount: controller.results.length,
            itemBuilder: (context, index) {
              final product = controller.results[index];

              return ProductCardWidget(
                product: product,
                onAddToCart: () {
                  // returns false if user is not logged in (redirected to login)
                  final bool added = Get.put(CartController()).addToCart(
                    product.id,
                    optimisticItem: CartItemModel(
                      product: product,
                      quantity: 1,
                      priceSnapshot: product.price,
                    ),
                  );

                  // only show success snackbar when item was actually added
                  if (added) {
                    Get.snackbar(
                      'Added to Cart',
                      '${product.name} added!',
                      backgroundColor: AppColors.primary,
                      colorText: AppColors.white,
                      snackPosition: SnackPosition.TOP,
                      margin: EdgeInsets.all(AppDimensions.spaceMD.w),
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
                onTap: () {
                  Get.toNamed(
                    AppRoutes.productDetails,
                    arguments: {'slug': product.slug},
                  );
                },
              );

              // return ProductCardWidget(
              //   product: product,
              //   onAddToCart: () {
              //     Get.snackbar(
              //       'Cart',
              //       '${product.name} added to cart!',
              //       backgroundColor: AppColors.primary,
              //       colorText: AppColors.white,
              //       snackPosition: SnackPosition.BOTTOM,
              //       margin: EdgeInsets.all(12.w),
              //     );
              //   },
              //   onTap: () {
              //     Get.toNamed(
              //       AppRoutes.productDetails,
              //       arguments: {'slug': product.slug},
              //     );
              //   },
              // );
            },
          ),
        ),
        Obx(() {
          if (controller.status.value.isLoadingMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
