import 'package:get/get.dart';
import '../controllers/orders_controller.dart';

/// orders module dependency injection binding
class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
