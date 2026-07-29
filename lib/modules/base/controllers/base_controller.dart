import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/screens/home_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../orders/screens/orders_screen.dart';
import '../../profile/screens/profile_screen.dart';

/// base app controller managing bottom navigation and page stack
class BaseController extends GetxController {
  // currently selected bottom nav tab index
  final RxInt selectedIndex = 0.obs;

  // list of root view pages aligned to bottom nav: Home|Categories|Cart|Orders|Account
  final List<Widget> pages = const [
    HomeScreen(), // index 0 — home
    CategoriesScreen(), // index 1 — categories
    CartScreen(), // index 2 — cart
    OrdersScreen(), // index 3 — orders
    ProfileScreen(), // index 4 — account/profile
  ];

  @override
  void onInit() {
    super.onInit();
    // read initial tab index from routing arguments if present
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['index'] != null) {
      selectedIndex.value = Get.arguments['index'] as int;
    }
  }

  /// switch the active bottom nav tab
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void goToHomeScreen() {
    selectedIndex.value = 0;
    update();
  }

  void goToCartScreen() {
    selectedIndex.value = 2;
    update();
  }

  void goToOrderScreen() {
    selectedIndex.value = 3;
    update();
  }
}
