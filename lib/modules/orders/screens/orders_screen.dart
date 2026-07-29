import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_controller.dart';
import 'widgets/orders_guest_widget.dart';
import 'widgets/orders_empty_widget.dart';
import 'widgets/orders_list_widget.dart';
import '../../../shared/common_widgets/loading_state_widget.dart';
import '../../../shared/common_widgets/error_state_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// my orders screen — scaffold shell delegating body to widget files
class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // manually inject controller if not registered
    if (!Get.isRegistered<OrdersController>()) {
      Get.put(OrdersController());
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text(
          AppStrings.myOrders,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Obx(() {
        // show guest prompt if user is not logged in — orders_guest_widget.dart
        if (!controller.isLoggedIn.value) {
          return const OrdersGuestWidget();
        }

        final statusVal = controller.status.value;

        if (statusVal.isLoading) {
          return const LoadingStateWidget(
            loadingMessage: 'Fetching your orders...',
          );
        }

        if (statusVal.isError) {
          return ErrorStateWidget(
            errorMessage: statusVal.errorMessage ?? 'Failed to load orders',
            onRetry: controller.fetchOrders,
          );
        }

        if (statusVal.isEmpty) {
          return const OrdersEmptyWidget();
        }

        // show orders list layout if successfully loaded — orders_list_widget.dart
        return OrdersListWidget(controller: controller);
      }),
    );
  }
}
