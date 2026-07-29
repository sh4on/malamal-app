import 'package:get/get.dart';
import '../../../../core/services/network_service.dart';
import '../../../../core/utils/mixins/pagination_mixin.dart';
import '../../../../data/models/product_model.dart';

/// controller for managing sub-category products list state and pagination
class SubCategoryProductsController extends GetxController
    with PaginationMixin {
  Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());
  RxList<ProductModel> products = <ProductModel>[].obs;

  String slug = '';
  String categoryName = '';
  bool isMainCategory = false;

  @override
  void onInit() {
    super.onInit();

    // get arguments passed from previous screen
    if (Get.arguments != null && Get.arguments is Map) {
      slug = Get.arguments['slug'] ?? '';
      categoryName = Get.arguments['name'] ?? 'Products';
      isMainCategory = Get.arguments['isMainCategory'] ?? false;
    }

    initPagination(_fetchMoreProducts);
    _fetchInitialProducts();
  }

  @override
  void onClose() {
    disposePagination();
    super.onClose();
  }

  /// fetch first page of products
  Future<void> _fetchInitialProducts() async {
    status.value = RxStatus.loading();
    currentPage = 1;
    products.clear();
    isLock = false;

    await _fetchProducts();
  }

  /// fetch next page of products when scrolling
  Future<void> _fetchMoreProducts() async {
    if (isLock || status.value.isLoadingMore) return;

    status.value = RxStatus.loadingMore();
    currentPage++;

    await _fetchProducts();
  }

  /// core fetch logic from API
  Future<void> _fetchProducts() async {
    isLock = true;
    final String typePath = isMainCategory ? 'by-category' : 'by-sub-category';
    final endpoint =
        '/product/products/$typePath/$slug?page=$currentPage&limit=$limit';

    final NetworkResult result = await NetworkService.instance.get(endpoint);

    if (result.isSuccess && result.data != null) {
      final responseData = result.data['data'] as List?;
      final meta = result.data['meta'];

      if (responseData != null) {
        final newProducts = responseData
            .map((e) => ProductModel.fromJson(e))
            .toList();
        products.addAll(newProducts);

        // determine next state
        if (products.isEmpty) {
          status.value = RxStatus.empty();
        } else {
          status.value = RxStatus.success();
        }

        // check if more pages available
        if (meta != null && meta['page'] >= meta['totalPages']) {
          // no more pages to load
        } else {
          isLock = false; // unlock to allow fetching next page
        }
      } else {
        if (products.isEmpty) {
          status.value = RxStatus.empty();
        } else {
          status.value = RxStatus.success();
        }
      }
    } else {
      if (products.isEmpty) {
        status.value = RxStatus.error(result.message);
      } else {
        // if error on pagination, just show success with existing items, maybe a snackbar
        status.value = RxStatus.success();
        Get.snackbar('Error', result.message ?? 'Failed to load more products');
      }
    }
  }

  /// retry fetching products
  void retry() {
    _fetchInitialProducts();
  }
}
