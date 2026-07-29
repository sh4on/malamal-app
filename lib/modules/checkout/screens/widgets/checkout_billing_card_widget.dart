import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/checkout_controller.dart';
import 'checkout_input_field.dart';

/// billing details card section with customer name, phone, email, address, city and notes
class CheckoutBillingCardWidget extends StatelessWidget {
  final CheckoutController controller;

  const CheckoutBillingCardWidget({
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
            // billing section header
            const Text(
              'Billing Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const Divider(height: 20),

            // full name field
            CheckoutInputField(
              label: 'Full Name *',
              controller: controller.nameController,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Name is required' : null,
            ),
            SizedBox(height: 12.h),

            // phone number field
            CheckoutInputField(
              label: 'Phone Number *',
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Phone is required' : null,
            ),
            SizedBox(height: 12.h),

            // email field
            CheckoutInputField(
              label: 'Email address *',
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Email is required' : null,
            ),
            SizedBox(height: 12.h),

            // street address field
            CheckoutInputField(
              label: 'Street Address *',
              controller: controller.addressController,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Address is required' : null,
            ),
            SizedBox(height: 12.h),

            // city field
            CheckoutInputField(
              label: 'City / District *',
              controller: controller.cityController,
              validator: (val) =>
                  val == null || val.isEmpty ? 'City is required' : null,
            ),
            SizedBox(height: 12.h),

            // optional order notes field
            CheckoutInputField(
              label: 'Order Notes (Optional)',
              controller: controller.noteController,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
