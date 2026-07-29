import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/app_colors.dart';

/// reusable global storefront product grid display card
class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double discountPercent = product.oldPrice != null
        ? ((product.oldPrice! - product.price) / product.oldPrice! * 100)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.white,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // product image section with discount tag
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4.r),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      memCacheHeight: 250,
                      memCacheWidth: 250,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.greyLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image, color: AppColors.grey),
                      ),
                    ),
                  ),
                ),
                if (product.oldPrice != null)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      color: AppColors.primary,
                      child: Text(
                        '-${discountPercent.round()}%',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // text details section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // brand name
                    if (product.brand != null)
                      Text(
                        product.brand!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    SizedBox(height: 4.h),
                    // product name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // rating indicators
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14.w),
                        SizedBox(width: 2.w),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.greyDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // pricing section
                    Row(
                      children: [
                        Text(
                          '৳${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (product.oldPrice != null) ...[
                          SizedBox(width: 6.w),
                          Text(
                            '৳${product.oldPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Spacer(),
                    // add to cart button
                    SizedBox(
                      width: double.infinity,
                      height: 32.h,
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        child: const Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
