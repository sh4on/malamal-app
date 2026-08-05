import 'package:get/get.dart';
import '../../../core/services/network_service.dart';
import '../../../data/models/order_model.dart';

/// order details controller managing the retrieval of single order payload by id
class OrderDetailsController extends GetxController {
  final NetworkService _networkService = NetworkService.instance;

  // order id passed from arguments
  String orderId = '';

  // reactive order details model
  final Rxn<OrderModel> order = Rxn<OrderModel>();

  // page loading status
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());

  @override
  void onInit() {
    super.onInit();
    // read order reference/id passed from orders list screen argument
    if (Get.arguments is String) {
      orderId = Get.arguments as String;
      fetchOrderDetails();
    } else {
      status.value = RxStatus.error('Invalid order reference argument');
    }
  }

  /// call GET /order/my-orders/:orderId to fetch detailed order information
  Future<void> fetchOrderDetails() async {
    status.value = RxStatus.loading();

    try {
      final result = await _networkService.get('/order/my-orders/$orderId');

      if (result.isSuccess && result.data != null) {
        final Map<String, dynamic> responseData = result.data as Map<String, dynamic>;
        final Map<String, dynamic>? data = responseData['data'] as Map<String, dynamic>?;

        if (data != null) {
          order.value = OrderModel.fromJson(data);
          status.value = RxStatus.success();
        } else {
          status.value = RxStatus.error('Order payload is empty');
        }
      } else {
        status.value = RxStatus.error(
          result.message ?? 'Failed to retrieve order details',
        );
      }
    } catch (e) {
      status.value = RxStatus.error('Something went wrong: $e');
    }
  }
}
