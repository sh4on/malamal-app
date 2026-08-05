import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/order_model.dart';

/// card widget displaying general order info: reference, date and status
class OrderDetailHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const OrderDetailHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // build header card with order reference, date, and normalized colored status tag
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.reference ?? order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontLG,
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
            if (order.createdAt != null)
              Text(
                _formatDate(order.createdAt),
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppDimensions.fontSM,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// helper to build status badge with dynamic colors based on current order status
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
      case 'PENDING_PAYMENT':
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
        normalized.replaceAll('_', ' '),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// format date representation into localized format
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
