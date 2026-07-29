import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../core/constants/app_colors.dart';

/// list view row row displaying details for a single cart item
class CartItemRow extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemRow({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
        side: BorderSide(color: AppColors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            // image thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: CachedNetworkImage(
                imageUrl: item.product.imageUrl,
                width: 60.w,
                height: 60.h,
                memCacheHeight: 120,
                memCacheWidth: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),

            // text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.product.brand != null)
                    Text(
                      item.product.brand!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 2.h),
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '৳${item.product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // quantity selectors
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: onDecrease,
                ),
                Text(
                  item.quantity.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: onIncrease,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                  onPressed: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
