import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_m/modules/brand/controllers/brand_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/common_widgets/empty_state_widget.dart';
import '../../../../shared/common_widgets/error_state_widget.dart';
import '../../../../shared/common_widgets/loading_state_widget.dart';
import 'widgets/brand_products_grid_widget.dart';

class BrandScreen extends GetView<BrandController> {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(controller.brandName),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0.5,
      ),
      body: Obx(() {
        final statusVal = controller.status.value;

        // loading state
        if (statusVal.isLoading) {
          return const LoadingStateWidget(
            loadingMessage: 'Loading products...',
          );
        }

        // error state with retry
        if (statusVal.isError) {
          return ErrorStateWidget(
            errorMessage: statusVal.errorMessage ?? 'Failed to load products.',
            onRetry: controller.retry,
          );
        }

        // empty state
        if (statusVal.isEmpty || controller.products.isEmpty) {
          return EmptyStateWidget(
            message: 'No products found for ${controller.brandName}.',
          );
        }

        // product grid
        return BrandProductsGridWidget(controller: controller);
      }),
    );
  }
}
