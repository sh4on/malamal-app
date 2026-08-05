import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/order_details_controller.dart';
import 'widgets/order_detail_header_widget.dart';
import 'widgets/order_detail_items_widget.dart';
import 'widgets/order_detail_shipping_widget.dart';
import 'widgets/order_detail_payment_widget.dart';
import 'widgets/order_detail_summary_widget.dart';
import '../../../shared/common_widgets/loading_state_widget.dart';
import '../../../shared/common_widgets/error_state_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// order details screen showing full info about a single order
class OrderDetailsScreen extends GetView<OrderDetailsController> {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: Obx(() {
        final statusVal = controller.status.value;

        if (statusVal.isLoading) {
          return const LoadingStateWidget(
            loadingMessage: 'Fetching order details...',
          );
        }

        if (statusVal.isError) {
          return ErrorStateWidget(
            errorMessage: statusVal.errorMessage ?? 'Failed to load order details',
            onRetry: controller.fetchOrderDetails,
          );
        }

        final order = controller.order.value;
        if (order == null) {
          return const Center(
            child: Text('No order details found.'),
          );
        }

        // build scrollable view containing the itemized blocks separated by spacing
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spaceLG.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderDetailHeaderWidget(order: order),
                SizedBox(height: AppDimensions.spaceMD.h),
                OrderDetailItemsWidget(order: order),
                SizedBox(height: AppDimensions.spaceMD.h),
                OrderDetailShippingWidget(order: order),
                SizedBox(height: AppDimensions.spaceMD.h),
                OrderDetailPaymentWidget(order: order),
                SizedBox(height: AppDimensions.spaceMD.h),
                OrderDetailSummaryWidget(order: order),
                SizedBox(height: kToolbarHeight.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
