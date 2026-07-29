import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart' as app_search;
import 'widgets/search_app_bar_widget.dart';
import 'widgets/search_body_widget.dart';
import '../../../core/constants/app_colors.dart';

/// search screen — scaffold shell delegating appbar and body to widget files
class SearchScreen extends GetView<app_search.SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // manually inject controller if not registered
    if (!Get.isRegistered<app_search.SearchController>()) {
      Get.put(app_search.SearchController());
    }

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      // embedded search field app bar — search_app_bar_widget.dart
      appBar: SearchAppBarWidget(controller: controller),
      // results + autocomplete overlay — search_body_widget.dart
      body: SearchBodyWidget(controller: controller),
    );
  }
}
