import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import '../controllers/home_controller.dart';
import 'widgets/home_app_bar_widget.dart';
import 'widgets/home_body_widget.dart';
import 'widgets/home_drawer_widget.dart';
import '../../../shared/common_widgets/loading_state_widget.dart';
import '../../../shared/common_widgets/error_state_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// main home screen — scaffold shell delegating content to widget files
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // manually inject controller if not registered
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }

    return UpgradeAlert(
      showIgnore: false,
      showLater: false,
      barrierDismissible: false,
      child: Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: AppColors.scaffold,
        // app bar extracted to home_app_bar_widget.dart
        appBar: const HomeAppBarWidget(),
        endDrawer: const HomeDrawerWidget(),
        body: Obx(() {
          final statusVal = controller.status.value;

          // loading state
          if (statusVal.isLoading) {
            return const LoadingStateWidget(
              loadingMessage: 'Loading Malamal...',
            );
          }

          // error state with retry
          if (statusVal.isError) {
            return ErrorStateWidget(
              errorMessage: statusVal.errorMessage ?? AppStrings.errorRetry,
              onRetry: controller.fetchHomeData,
            );
          }

          // success state — body extracted to home_body_widget.dart
          return const HomeBodyWidget();
        }),
      ),
    );
  }
}
