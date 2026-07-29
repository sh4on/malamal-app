import 'package:get/get.dart';
import '../controllers/base_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../categories/controllers/categories_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../profile/controllers/profile_controller.dart';

/// base route dependency injection — registers all tab controllers eagerly
class BaseBinding extends Bindings {
  @override
  void dependencies() {
    // base navigation controller
    Get.lazyPut<BaseController>(() => BaseController());
    // home tab — loads api data on init
    Get.lazyPut<HomeController>(() => HomeController());
    // categories tab — syncs from home controller
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    // cart tab
    Get.lazyPut<CartController>(() => CartController());
    // orders tab
    Get.lazyPut<OrdersController>(() => OrdersController());
    // profile/account tab
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
