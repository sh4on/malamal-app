import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/checkout_controller.dart';
import 'checkout_input_field.dart';

/// coupon code entry card section in checkout
class CheckoutCouponCardWidget extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutCouponCardWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0.5,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Have a Coupon?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: 8.h),
            // coupon input + apply button in a row
            Row(
              children: [
                Expanded(
                  child: CheckoutInputField(
                    label: 'Coupon Code',
                    controller: controller.couponController,
                    showLabelText: false,
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
