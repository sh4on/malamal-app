import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/order_model.dart';

/// card section showing customer shipping and contact details
class OrderDetailShippingWidget extends StatelessWidget {
  final OrderModel order;

  const OrderDetailShippingWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final customer = order.customer;

    // build shipping card listing customer name, address, contact numbers, and optional checkout notes
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
              'Shipping & Customer Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontMD,
                color: AppColors.secondary,
              ),
            ),
            const Divider(color: AppColors.greyBorder, height: 20),
            _buildDetailRow('Customer Name', customer.name),
            SizedBox(height: 8.h),
            _buildDetailRow('Phone Number', customer.phone),
            SizedBox(height: 8.h),
            _buildDetailRow('Email Address', customer.email),
            SizedBox(height: 8.h),
            _buildDetailRow('Street Address', customer.address),
            SizedBox(height: 8.h),
            _buildDetailRow('City / District', customer.city),
            if (customer.note != null && customer.note!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildDetailRow('Order Note', customer.note!),
            ],
          ],
        ),
      ),
    );
  }

  /// build a neat left-right aligned row for label and text details
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
}
