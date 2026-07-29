import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/models/product_details_model.dart';

/// product info header widget — brand, title, sku, rating, price, stock status
class ProductInfoHeaderWidget extends StatelessWidget {
  final ProductDetailsModel product;

  const ProductInfoHeaderWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG.w,
        vertical: AppDimensions.spaceMD.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // brand name chip
          if (product.brand != null)
            Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spaceSM.h),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSM.w,
                vertical: AppDimensions.spaceXS.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              child: Text(
                product.brand!.name.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: AppDimensions.fontXS,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),

          // product title
          Text(
            product.title,
            style: const TextStyle(
              fontSize: AppDimensions.fontXL,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              height: 1.3,
            ),
          ),
          SizedBox(height: AppDimensions.spaceSM.h),

          // sku and stock status row
          Row(
            children: [
              // sku label
              Text(
                '${AppStrings.sku}: ${product.sku}',
                style: const TextStyle(
                  fontSize: AppDimensions.fontSM,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: AppDimensions.spaceMD.w),

              // stock status indicator
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceSM.w,
                  vertical: AppDimensions.spaceXXS.h,
                ),
                decoration: BoxDecoration(
                  color: product.inStock
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      product.inStock
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      size: AppDimensions.iconSM,
                      color: product.inStock
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    SizedBox(width: AppDimensions.spaceXS.w),
                    Text(
                      product.inStock
                          ? AppStrings.inStockLabel
                          : AppStrings.outOfStock,
                      style: TextStyle(
                        fontSize: AppDimensions.fontXS,
                        fontWeight: FontWeight.w600,
                        color: product.inStock
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceMD.h),

          // rating row
          if (product.rating > 0)
            Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spaceMD.h),
              child: Row(
                children: [
                  // star icons
                  ...List.generate(5, (index) {
                    return Icon(
                      index < product.rating.round()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: AppDimensions.iconMD,
                    );
                  }),
                  SizedBox(width: AppDimensions.spaceXS.w),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSM,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyDark,
                    ),
                  ),
                ],
              ),
            ),

          // price section
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // current price
              Text(
                '৳${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: AppDimensions.fontXXL,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              // selling unit
              Text(
                ' / ${product.sellingUnit}',
                style: const TextStyle(
                  fontSize: AppDimensions.fontMD,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyDark,
                ),
              ),
              // old price with strikethrough
              if (product.oldPrice != null) ...[
                SizedBox(width: AppDimensions.spaceSM.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    '৳${product.oldPrice!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: AppDimensions.fontMD,
                      color: AppColors.grey,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.grey,
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.spaceSM.w),
                // discount percentage chip
                if (product.discountPercent > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSM.w,
                      vertical: AppDimensions.spaceXXS.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.discount.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSM,
                      ),
                    ),
                    child: Text(
                      '-${product.discountPercent.round()}%',
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSM,
                        fontWeight: FontWeight.w700,
                        color: AppColors.discount,
                      ),
                    ),
                  ),
              ],
            ],
          ),

          // weight info row
          if (product.weightKg != null)
            Padding(
              padding: EdgeInsets.only(top: AppDimensions.spaceMD.h),
              child: Row(
                children: [
                  const Icon(
                    Icons.scale_outlined,
                    size: AppDimensions.iconSM,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: AppDimensions.spaceXS.w),
                  Text(
                    'Weight: ${product.weightKg!.toStringAsFixed(0)} kg',
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSM,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // category label
          if (product.category != null)
            Padding(
              padding: EdgeInsets.only(top: AppDimensions.spaceSM.h),
              child: Row(
                children: [
                  const Icon(
                    Icons.category_outlined,
                    size: AppDimensions.iconSM,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: AppDimensions.spaceXS.w),
                  Text(
                    product.category!.name,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSM,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
