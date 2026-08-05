import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/order_model.dart';

/// card section displaying the list of purchased items and their quantities
class OrderDetailItemsWidget extends StatelessWidget {
  final OrderModel order;

  const OrderDetailItemsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // build items list card container wrapping detailed single rows
    return Card(
      color: AppColors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
        side: const BorderSide(color: AppColors.greyBorder, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceMD.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ordered Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontMD,
                color: AppColors.secondary,
              ),
            ),
            const Divider(color: AppColors.greyBorder, height: 20),
            Column(
              children: order.items.map((item) => _buildItemRow(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// build single order item row with picture, title, qty, price, and total line calculation
  Widget _buildItemRow(OrderItem item) {
    final double itemPrice = item.price ?? 0.0;
    final int itemQuantity = item.quantity;
    final double lineTotal = itemPrice * itemQuantity;

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spaceMD.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
            child: SizedBox(
              width: 50.w,
              height: 50.w,
              child: item.image != null && item.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.image!,
                      memCacheHeight: 100,
                      memCacheWidth: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.greyLight,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.grey,
                      ),
                    )
                  : Container(
                      color: AppColors.greyLight,
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.grey,
                      ),
                    ),
            ),
          ),
          SizedBox(width: AppDimensions.spaceMD.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? 'Product SKU: ${item.sku}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimensions.fontSM,
                    color: AppColors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '৳${itemPrice.toStringAsFixed(0)} x $itemQuantity',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.spaceSM.w),
          Text(
            '৳${lineTotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontSM,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
