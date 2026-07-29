import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_m/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../../shared/common_widgets/product_card_widget.dart';
import '../../../cart/controllers/cart_controller.dart';

/// 2-column products grid for the home screen (reused for featured and latest)
class HomeProductGridWidget extends StatelessWidget {
  final RxList<ProductModel> products;

  const HomeProductGridWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.52,
            crossAxisSpacing: AppDimensions.spaceSM.w,
            mainAxisSpacing: AppDimensions.spaceSM.h,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
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
                debugPrint('xxx ${product.slug}');
                Get.toNamed(
                  AppRoutes.productDetails,
                  arguments: {'slug': product.slug},
                );
              },
            );
          },
        ),
      ),
    );
  }
}
