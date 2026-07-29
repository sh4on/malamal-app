import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/categories_controller.dart';
import 'widgets/category_list_tile_widget.dart';
import '../../../shared/common_widgets/loading_state_widget.dart';
import '../../../shared/common_widgets/error_state_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// all categories screen — scaffold shell with expandable category list
class CategoriesScreen extends GetView<CategoriesController> {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // manually inject controller if not registered
    if (!Get.isRegistered<CategoriesController>()) {
      Get.put(CategoriesController());
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text(
          AppStrings.allCategories,
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
        final statusVal = controller.status.value;

        // loading state
        if (statusVal.isLoading) {
          return const LoadingStateWidget(loadingMessage: 'Loading categories...');
        }

        // error state with retry
        if (statusVal.isError) {
          return ErrorStateWidget(
            errorMessage: statusVal.errorMessage ?? AppStrings.errorRetry,
            onRetry: controller.syncFromHomeController,
          );
        }

        // empty state
        if (statusVal.isEmpty || controller.categories.isEmpty) {
          return const Center(
            child: Text(
              'No categories found.',
              style: TextStyle(color: AppColors.grey, fontSize: AppDimensions.fontMD),
            ),
          );
        }

        // expandable category list — each tile extracted to category_list_tile_widget.dart
        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLG.w,
            vertical: AppDimensions.spaceSM.h,
          ),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            return CategoryListTileWidget(
              category: controller.categories[index],
            );
          },
        );
      }),
    );
  }
}
