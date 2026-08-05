import 'package:get/get.dart';
import '../controllers/order_details_controller.dart';

/// order details route binding setup lazily initializing the details controller
class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsController>(() => OrderDetailsController());
  }
}
