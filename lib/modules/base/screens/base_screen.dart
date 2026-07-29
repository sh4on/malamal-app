import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_m/core/utils/helper_methods/helper_methods.dart';
import '../controllers/base_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// primary app shell with bottom navigation bar and WhatsApp FAB
class BaseScreen extends GetView<BaseController> {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // set status bar style to dark icons on white background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool isDrawerOpen = false;
        if (Get.isRegistered<HomeController>()) {
          isDrawerOpen =
              Get.find<HomeController>()
                  .scaffoldKey
                  .currentState
                  ?.isEndDrawerOpen ??
              false;
        }

        if (isDrawerOpen) {
          Get.find<HomeController>().scaffoldKey.currentState?.closeEndDrawer();
        } else if (controller.selectedIndex.value != 0) {
          // not on home tab, so switch to home tab
          controller.changeIndex(0);
        } else {
          // on home tab, show exit confirmation
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Exit App',
                style: TextStyle(color: AppColors.primary),
              ),
              content: const Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'No',
                    style: TextStyle(color: AppColors.greyDark),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          );

          if (shouldExit == true) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        // indexed page stack for each bottom nav tab
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.pages,
          ),
        ),
        // whatsapp support floating action button
        floatingActionButton: _buildWhatsAppFab(),
        // bottom navigation bar matching malamal.com.bd tabs
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  /// build the WhatsApp floating action button
  Widget _buildWhatsAppFab() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () async {
        await openWhatsApp();
      },
      backgroundColor: AppColors.whatsapp,
      elevation: AppDimensions.elevationMD,
      child: const Icon(CupertinoIcons.chat_bubble, color: AppColors.white),
    );
  }

  /// build the bottom navigation bar with 5 tabs
  Widget _buildBottomNavBar() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: .08),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey,
          backgroundColor: AppColors.white,
          elevation: 0, // elevation handled by container shadow above
          selectedFontSize: AppDimensions.fontXS,
          unselectedFontSize: AppDimensions.fontXS,
          // bottom nav tabs: Home | Categories | Cart | Orders | Account
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: AppDimensions.iconLG.w),
              activeIcon: Icon(Icons.home, size: AppDimensions.iconLG.w),
              label: AppStrings.navHome,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.grid_view_outlined,
                size: AppDimensions.iconLG.w,
              ),
              activeIcon: Icon(
                Icons.grid_view_rounded,
                size: AppDimensions.iconLG.w,
              ),
              label: AppStrings.navCategories,
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: AppDimensions.iconLG.w,
                  ),
                  _buildCartBadge(),
                ],
              ),
              activeIcon: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: AppDimensions.iconLG.w),
                  _buildCartBadge(),
                ],
              ),
              label: AppStrings.navCart,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt_long_outlined,
                size: AppDimensions.iconLG.w,
              ),
              activeIcon: Icon(
                Icons.receipt_long,
                size: AppDimensions.iconLG.w,
              ),
              label: AppStrings.navOrders,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: AppDimensions.iconLG.w),
              activeIcon: Icon(Icons.person, size: AppDimensions.iconLG.w),
              label: AppStrings.navAccount,
            ),
          ],
        ),
      ),
    );
  }

  /// build the cart badge for the bottom nav bar
  Widget _buildCartBadge() {
    return Obx(() {
      final cartCount = Get.put(CartController()).cartItems.length;
      if (cartCount == 0) return const SizedBox.shrink();
      return Positioned(
        top: -4,
        right: -8,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 1),
          ),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          child: Text(
            '$cartCount',
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}
