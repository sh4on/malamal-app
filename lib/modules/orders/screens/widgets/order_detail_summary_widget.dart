import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/order_model.dart';

/// card section showing the financial summary breakdown
class OrderDetailSummaryWidget extends StatelessWidget {
  final OrderModel order;

  const OrderDetailSummaryWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final double subtotalVal = order.subtotal ?? (order.amount - (order.shippingCharge ?? 0.0));
    final double shippingVal = order.shippingCharge ?? 0.0;

    // build payment summary card containing breakdown list: subtotal, shipping charge, and final grand total
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
              'Order Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontMD,
                color: AppColors.secondary,
              ),
            ),
            const Divider(color: AppColors.greyBorder, height: 20),
            _buildSummaryRow('Subtotal', '৳${subtotalVal.toStringAsFixed(0)}'),
            SizedBox(height: 8.h),
            _buildSummaryRow('Delivery Charge', '৳${shippingVal.toStringAsFixed(0)}'),
            const Divider(color: AppColors.greyBorder, height: 20),
            _buildTotalRow('Total Amount', '৳${order.amount.toStringAsFixed(0)}'),
          ],
        ),
      ),
    );
  }

  /// build a standard summary item row
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.greyDark,
            fontSize: AppDimensions.fontSM,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: AppDimensions.fontSM,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// build the highlighted grand total row
  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondary,
            fontSize: AppDimensions.fontMD,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: AppDimensions.fontLG,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
