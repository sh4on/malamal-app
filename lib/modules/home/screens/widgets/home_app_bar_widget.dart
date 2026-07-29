import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../routes/app_routes.dart';

/// home screen app bar with malamal two-tone logo, search icon, and drawer menu
class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({super.key});

  @override
  // preferred size for the standard material app bar height
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      scrolledUnderElevation: 0,
      elevation: 0,
      // malamal two-tone logo: "Mala" in navy, "mal" in orange-red
      title: Image.asset(
        'assets/logo.webp',
        height: context.width * 0.10,
        width: context.width * 0.4,
      ),
      actions: [
        // search icon — navigates to search screen
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.secondary),
          onPressed: () {
            Get.toNamed(AppRoutes.search);
          },
        ),
        // drawer menu icon
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: AppColors.secondary),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
        SizedBox(width: AppDimensions.spaceXS.w),
      ],
    );
  }
}
