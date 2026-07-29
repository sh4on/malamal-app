import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controllers/search_controller.dart' as app_search;

/// search screen app bar with embedded text input field and clear button
class SearchAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final app_search.SearchController controller;

  const SearchAppBarWidget({
    super.key,
    required this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      // simple screen navigation back arrow button
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
        onPressed: () => Get.back(),
      ),
      // standard app title text
      title: const Text(
        'Search Products',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
