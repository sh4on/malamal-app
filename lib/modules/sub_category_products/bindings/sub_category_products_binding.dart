import 'package:get/get.dart';
import '../controllers/sub_category_products_controller.dart';

/// binding for sub-category products screen
class SubCategoryProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubCategoryProductsController>(
      () => SubCategoryProductsController(),
    );
  }
}
