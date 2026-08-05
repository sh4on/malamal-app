import 'package:get/get.dart';
import 'package:project_m/modules/brand/bindings/brand_binding.dart';
import 'package:project_m/modules/product_details/bindings/product_details_binding.dart';
import 'package:project_m/modules/product_details/screens/product_details_screen.dart';
import '../modules/base/bindings/base_binding.dart';
import '../modules/base/screens/base_screen.dart';
import '../modules/auth/screens/auth_screen.dart';
import '../modules/brand/screens/brand_screen.dart';
import '../modules/checkout/screens/checkout_screen.dart';
import '../modules/sub_category_products/bindings/sub_category_products_binding.dart';
import '../modules/sub_category_products/screens/sub_category_products_screen.dart';
import '../modules/search/screens/search_screen.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/profile/screens/account_information_screen.dart';
import '../modules/profile/screens/change_password_screen.dart';
import '../modules/profile/controllers/change_password_controller.dart';
import '../modules/orders/bindings/order_details_binding.dart';
import '../modules/orders/screens/order_details_screen.dart';
import 'app_routes.dart';

/// app routes list definitions and bindings
class AppPages {
  // initial start path
  static const String initial = AppRoutes.base;

  // list of active page configurations
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.base,
      page: () => const BaseScreen(),
      binding: BaseBinding(),
    ),
    GetPage(name: AppRoutes.auth, page: () => const AuthScreen()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(
      name: AppRoutes.orderDetails,
      page: () => const OrderDetailsScreen(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsScreen(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.brand,
      page: () => const BrandScreen(),
      binding: BrandBinding(),
    ),
    GetPage(
      name: AppRoutes.subCategoryProducts,
      page: () => const SubCategoryProductsScreen(),
      binding: SubCategoryProductsBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.accountInfo,
      page: () => const AccountInformationScreen(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
      }),
    ),
  ];
}
