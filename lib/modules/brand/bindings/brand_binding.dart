import 'package:get/get.dart';
import 'package:project_m/modules/brand/controllers/brand_controller.dart';

class BrandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BrandController());
  }
}
