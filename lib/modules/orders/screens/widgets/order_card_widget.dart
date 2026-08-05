import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/order_model.dart';
import '../../../../routes/app_routes.dart';

/// custom card widget representing a single order summary and its products
class OrderCardWidget extends StatelessWidget {
  final OrderModel order;

  const OrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate to order details page with orderId argument
        Get.toNamed(
          AppRoutes.orderDetails,
          arguments: order.reference ?? order.id,
        );
      },
      child: Card(
        color: AppColors.white,
      elevation: 0.5,
      margin: EdgeInsets.only(
        left: AppDimensions.spaceLG.w,
        right: AppDimensions.spaceLG.w,
        bottom: AppDimensions.spaceMD.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD.r),
        side: const BorderSide(color: AppColors.greyBorder, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceMD.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top header line: order id + status tag chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.reference ?? order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontMD,
                      color: AppColors.secondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            SizedBox(height: AppDimensions.spaceXS.h),
            // datetime line
            if (order.createdAt != null) ...[
              Text(
                _formatDate(order.createdAt),
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppDimensions.fontSM,
                ),
              ),
              SizedBox(height: AppDimensions.spaceMD.h),
            ],
            const Divider(color: AppColors.greyBorder, height: 1),
            SizedBox(height: AppDimensions.spaceMD.h),
            // items list column
            Column(
              children: order.items.map((item) => _buildItemRow(item)).toList(),
            ),
            const Divider(color: AppColors.greyBorder, height: 1),
            SizedBox(height: AppDimensions.spaceMD.h),
            // total summary footer details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment: ${order.paymentMethod.replaceAll('_', ' ')}',
                  style: const TextStyle(
                    color: AppColors.greyDark,
                    fontSize: AppDimensions.fontSM,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Total: ',
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: AppDimensions.fontSM,
                    ),
                    children: [
                      TextSpan(
                        text: '৳${order.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.fontMD,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  /// helper method to draw status badge colored dynamically based on status name
  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;
    final normalized = status.toUpperCase();

    switch (normalized) {
      case 'DELIVERED':
        chipColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case 'CONFIRMED':
        chipColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case 'PENDING':
        chipColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case 'CANCELLED':
        chipColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        break;
      default:
        chipColor = AppColors.greyLight;
        textColor = AppColors.greyDark;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM.r),
      ),
      child: Text(
        normalized,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// build single item entry row layout
  Widget _buildItemRow(OrderItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spaceMD.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // product thumbnail image placeholder using CachedNetworkImage
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
          // title details
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'QTY: ${item.quantity}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.spaceSM.w),
          // pricing totals details
          Text(
            '৳${((item.price ?? 0.0) * item.quantity).toStringAsFixed(0)}',
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

  /// custom string formatter converting iso string date representation
  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final minutesStr = date.minute.toString().padLeft(2, '0');
      return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:$minutesStr';
    } catch (_) {
      return dateStr;
    }
  }
}
