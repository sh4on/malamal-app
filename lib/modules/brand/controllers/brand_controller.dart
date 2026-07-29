import 'package:get/get.dart';
import '../../../../core/services/network_service.dart';
import '../../../../core/utils/mixins/pagination_mixin.dart';
import '../../../../data/models/product_model.dart';

class BrandController extends GetxController with PaginationMixin {
  final NetworkService _networkService = NetworkService.instance;
  
  RxList<ProductModel> products = <ProductModel>[].obs;
  Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());

  String brandId = '';
  String brandName = 'Brand Products';
  bool hasNextPage = true;

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null && Get.arguments is Map) {
      brandId = Get.arguments['brand_id'] ?? '';
      brandName = Get.arguments['brand_name'] ?? 'Brand Products';
    }

    initPagination(() {
      if (hasNextPage && !isLock && !status.value.isLoadingMore) {
        _fetchBrandProducts(isLoadMore: true);
      }
    });

    if (brandId.isNotEmpty) {
      _fetchBrandProducts();
    } else {
      status.value = RxStatus.error('Invalid Brand ID');
    }
  }

  Future<void> _fetchBrandProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      status.value = RxStatus.loadingMore();
      currentPage++;
    } else {
      status.value = RxStatus.loading();
      currentPage = 1;
      products.clear();
      hasNextPage = true;
    }
    
    isLock = true;
    
    final endpoint = 'https://api.malamal.com.bd/api/v1/product/all?limit=$limit&page=$currentPage&brand=$brandId';
    final result = await _networkService.get(endpoint);

    if (result.isSuccess) {
      final List data = result.data?['data'] ?? [];
      final int totalPages = result.data?['meta']?['totalPages'] ?? 1;
      
      final List<ProductModel> newProducts = data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (isLoadMore) {
        products.addAll(newProducts);
      } else {
        products.assignAll(newProducts);
      }
      
      hasNextPage = currentPage < totalPages;

      if (products.isEmpty) {
        status.value = RxStatus.empty();
      } else {
        status.value = RxStatus.success();
      }
    } else {
      status.value = RxStatus.error(result.message);
      if (isLoadMore) {
        currentPage--;
      }
    }
    
    isLock = false;
  }

  void retry() {
    _fetchBrandProducts();
  }

  @override
  void onClose() {
    disposePagination();
    super.onClose();
  }
}
