import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../controllers/orders_controller.dart';
import 'order_card_widget.dart';

/// list panel wrapper displaying list of orders with pull-to-refresh support
class OrdersListWidget extends StatelessWidget {
  final OrdersController controller;

  const OrdersListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchOrders,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceMD.h),
        itemCount: controller.orders.length,
        itemBuilder: (context, index) {
          final order = controller.orders[index];
          return OrderCardWidget(order: order);
        },
      ),
    );
  }
}
