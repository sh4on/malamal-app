import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_m/core/constants/app_api.dart';
import 'package:project_m/core/services/network_service.dart';
import 'package:project_m/data/models/cart_item_model.dart';
import 'package:project_m/data/models/product_details_model.dart';
import 'package:project_m/data/models/product_model.dart';
import 'package:project_m/modules/cart/controllers/cart_controller.dart';

/// controller for the product details screen, handles api fetch, state, and cart actions
class ProductDetailsController extends GetxController {
  // reactive state management
  Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());

  // product details data
  Rx<ProductDetailsModel?> product = Rx<ProductDetailsModel?>(null);

  // image carousel selection index
  RxInt selectedImageIndex = 0.obs;

  // quantity selector
  RxInt quantity = 1.obs;

  // slug from navigation arguments
  late final String slug;

  @override
  void onInit() {
    super.onInit();

    // extract slug from navigation arguments
    if (Get.arguments != null && Get.arguments is Map) {
      slug = Get.arguments['slug'];
      debugPrint('ProductDetails slug: $slug');
    }

    getProductDetails();
  }

  /// fetch product details from api by slug
  Future<void> getProductDetails() async {
    status.value = RxStatus.loading();
    final String apiUrl = '${AppApi.productDetails}/$slug';

    try {
      final result = await NetworkService.instance.get(apiUrl);

      if (result.isSuccess && result.data != null) {
        // parse the nested data object from the api response
        final Map<String, dynamic> responseData =
            result.data is Map<String, dynamic>
                ? result.data as Map<String, dynamic>
                : {};

        if (responseData['data'] != null) {
          product.value = ProductDetailsModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          );
          status.value = RxStatus.success();
        } else {
          status.value = RxStatus.error('Product not found');
        }
      } else {
        status.value = RxStatus.error(result.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('ProductDetails error: $e');
      status.value = RxStatus.error(e.toString());
    }
  }

  /// increment quantity
  void incrementQty() {
    quantity.value++;
  }

  /// decrement quantity (minimum 1)
  void decrementQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  /// update selected image index from carousel swipe
  void onImagePageChanged(int index) {
    selectedImageIndex.value = index;
  }

  /// add the current product to cart with selected quantity.
  /// returns false if user is not logged in (redirected to login), true if added.
  bool addToCart() {
    final currentProduct = product.value;
    if (currentProduct == null) return false;

    // build a ProductModel for the optimistic cart item placeholder
    final ProductModel cartProduct = ProductModel(
      id: currentProduct.id,
      name: currentProduct.title,
      slug: currentProduct.slug,
      sku: currentProduct.sku,
      description: currentProduct.description,
      imageUrl: currentProduct.images.isNotEmpty
          ? currentProduct.images.first
          : 'https://picsum.photos/200',
      price: currentProduct.price,
      oldPrice: currentProduct.oldPrice,
      rating: currentProduct.rating,
      brand: currentProduct.brand?.name,
      category: currentProduct.category?.name,
      inStock: currentProduct.inStock,
    );

    // build optimistic cart item so the badge updates instantly
    final CartItemModel optimisticItem = CartItemModel(
      product: cartProduct,
      quantity: quantity.value,
      priceSnapshot: currentProduct.price,
    );

    // fire-and-forget — propagate the bool result to the call site
    final CartController cartController = Get.put(CartController());
    return cartController.addToCart(
      currentProduct.id,
      quantity: quantity.value,
      optimisticItem: optimisticItem,
    );
  }
}
