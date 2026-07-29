import 'package:get/get.dart';
import '../controllers/categories_controller.dart';

/// categories module dependency injection binding
class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoriesController>(() => CategoriesController());
  }
}
