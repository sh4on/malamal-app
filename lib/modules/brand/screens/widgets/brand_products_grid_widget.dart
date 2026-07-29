import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../shared/common_widgets/product_card_widget.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../controllers/brand_controller.dart';

/// grid widget to display brand products
class BrandProductsGridWidget extends StatelessWidget {
  final BrandController controller;

  const BrandProductsGridWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD.w,
        vertical: AppDimensions.spaceMD.h,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.52,
        crossAxisSpacing: AppDimensions.spaceSM.w,
        mainAxisSpacing: AppDimensions.spaceSM.h,
      ),
      itemCount:
          controller.products.length +
          (controller.status.value.isLoadingMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index < controller.products.length) {
          final product = controller.products[index];
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
        } else {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: AppColors.primary),
          );
        }
      },
    );
  }
}
