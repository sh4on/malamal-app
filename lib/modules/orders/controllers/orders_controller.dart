import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/network_service.dart';
import '../../../data/models/order_model.dart';
import '../../base/controllers/base_controller.dart';

/// orders controller managing authenticated orders fetching and page transition listeners
class OrdersController extends GetxController {
  final NetworkService _networkService = NetworkService.instance;

  // login state (false = guest user)
  final RxBool isLoggedIn = false.obs;

  // list of active orders retrieved from API
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  // page loading status
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());

  @override
  void onInit() {
    super.onInit();
    
    // register listener on bottom nav changes to trigger auto-reload on tab index 3 (Orders)
    if (Get.isRegistered<BaseController>()) {
      ever(Get.find<BaseController>().selectedIndex, (int index) {
        if (index == 3) {
          checkAuthSessionAndFetch();
        }
      });
    }

    checkAuthSessionAndFetch();
  }

  /// inspect preferences for token and fetch profile orders
  Future<void> checkAuthSessionAndFetch() async {
    status.value = RxStatus.loading();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedToken = prefs.getString('token');
      if (savedToken != null && savedToken.isNotEmpty) {
        isLoggedIn.value = true;
        _networkService.setToken(savedToken);
        await fetchOrders();
      } else {
        isLoggedIn.value = false;
        orders.clear();
        status.value = RxStatus.empty();
      }
    } catch (e) {
      isLoggedIn.value = false;
      status.value = RxStatus.error(e.toString());
    }
  }

  /// call GET /order/my-orders directly to pull orders history list
  Future<void> fetchOrders() async {
    status.value = RxStatus.loading();
    final result = await _networkService.get('/order/my-orders');

    if (result.isSuccess && result.data != null) {
      try {
        final List dataList = result.data?['data'] ?? [];
        final fetchedOrders = dataList
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        orders.assignAll(fetchedOrders);
        if (orders.isEmpty) {
          status.value = RxStatus.empty();
        } else {
          status.value = RxStatus.success();
        }
      } catch (e) {
        status.value = RxStatus.error('Failed to parse orders data');
      }
    } else {
      status.value = RxStatus.error(result.message ?? 'Failed to retrieve orders');
    }
  }
}
