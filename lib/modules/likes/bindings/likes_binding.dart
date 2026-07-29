import 'package:get/get.dart';
import '../controllers/likes_controller.dart';

/// likes flow binding dependency registration
class LikesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikesController>(() => LikesController());
  }
}
