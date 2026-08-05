import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/order_model.dart';

/// card section representing order payment method, gateway, and billing status
class OrderDetailPaymentWidget extends StatelessWidget {
  final OrderModel order;

  const OrderDetailPaymentWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // build card container showing payment method details, gateway information, and payment status colors
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
              'Payment Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontMD,
                color: AppColors.secondary,
              ),
            ),
            const Divider(color: AppColors.greyBorder, height: 20),
            _buildDetailRow('Payment Method', order.paymentMethod.replaceAll('_', ' ')),
            SizedBox(height: 8.h),
            _buildStatusRow('Payment Status', order.status),
          ],
        ),
      ),
    );
  }

  /// build simple detail row helper
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: AppDimensions.fontSM,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: AppDimensions.fontSM,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// build colored status row showing text matching status states (paid/unpaid)
  Widget _buildStatusRow(String label, String status) {
    final normalized = status.toUpperCase();
    final bool isPaid = normalized == 'PAID' || normalized == 'COMPLETED' || normalized == 'DELIVERED';
    final Color textColor = isPaid ? AppColors.success : AppColors.error;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: AppDimensions.fontSM,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            normalized.replaceAll('_', ' '),
            style: TextStyle(
              color: textColor,
              fontSize: AppDimensions.fontSM,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
