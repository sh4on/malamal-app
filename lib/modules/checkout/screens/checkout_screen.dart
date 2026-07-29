import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/checkout_controller.dart';
import 'widgets/checkout_billing_card_widget.dart';
import 'widgets/checkout_payment_card_widget.dart';
import 'widgets/checkout_summary_card_widget.dart';
import '../../../core/constants/app_colors.dart';

/// checkout screen — scaffold shell with billing form, coupon, payment & summary cards
class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // manually inject controller if not registered
    if (!Get.isRegistered<CheckoutController>()) {
      Get.put(CheckoutController());
    }

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // billing details card — checkout_billing_card_widget.dart
                CheckoutBillingCardWidget(controller: controller),
                SizedBox(height: 16.h),

                // coupon code card — checkout_coupon_card_widget.dart
                // CheckoutCouponCardWidget(controller: controller),
                // SizedBox(height: 16.h),

                // payment method card — checkout_payment_card_widget.dart
                CheckoutPaymentCardWidget(controller: controller),
                SizedBox(height: 16.h),

                // order total + place order card — checkout_summary_card_widget.dart
                CheckoutSummaryCardWidget(controller: controller),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
