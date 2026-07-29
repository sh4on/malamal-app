import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

/// profile screen binding setup
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
