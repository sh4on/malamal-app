import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// home module bindings dependency injection configuration
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
