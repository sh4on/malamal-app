import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// auth flow binding dependency registration
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
