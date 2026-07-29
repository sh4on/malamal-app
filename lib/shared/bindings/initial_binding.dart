import 'package:get/get.dart';
import '../../core/services/network_service.dart';

/// global bindings registered at app launch
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // register global services here
    Get.lazyPut<NetworkService>(() => NetworkService.instance, fenix: true);
  }
}
