import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../core/services/network_service.dart';
import '../../profile/controllers/profile_controller.dart';

/// cart controller — fully api-driven, no local storage
/// all mutation calls (add/update/remove/clear) are fire-and-forget
/// so the ui updates instantly without waiting for server response
class CartController extends GetxController {
  final NetworkService _networkService = NetworkService.instance;

  // reactive cart items list driven by api data
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  // internal map for O(1) lookup by product id
  final RxMap<String, CartItemModel> _cartItemsMap = <String, CartItemModel>{}.obs;

  // page loading state (only for the cart screen initial fetch)
  // start as empty so guest users never see the loading spinner
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.empty());

  // public reactive login state — CartScreen observes this to show the guest prompt
  final RxBool isLoggedIn = false.obs;

  // order summary reactive values
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 120.0.obs; // flat rate shipping
  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    // listen to login state changes — when the user logs in (or app restores
    // session after launch), automatically fetch cart from api.
    // this handles two cases:
    //   1. app reopen: ProfileController.checkAuthSession() is async and may
    //      complete after CartController.onInit(), so fetchCart() here would
    //      run before isLoggedIn = true. The ever() listener catches that.
    //   2. after login: isLoggedIn flips to true → cart loads automatically.
    if (Get.isRegistered<ProfileController>()) {
      final ProfileController profileController = Get.find<ProfileController>();

      // sync initial login state immediately so the screen shows the right view
      isLoggedIn.value = profileController.isLoggedIn.value;

      // listen to login state changes and keep isLoggedIn in sync
      ever(
        profileController.isLoggedIn,
        (bool loggedIn) {
          isLoggedIn.value = loggedIn;
          if (loggedIn) {
            fetchCart();
          } else {
            // user logged out — clear cart data and reset to guest state
            _cartItemsMap.clear();
            _updateFromMap();
            status.value = RxStatus.empty();
          }
        },
      );
    } else {
      // ProfileController not yet registered — try a direct fetch (covers
      // cases where CartController is created after auth is already confirmed)
      fetchCart();
    }
  }

  // ─── helpers ────────────────────────────────────────────────────────────────

  /// check if user is currently authenticated via ProfileController
  bool _isLoggedIn() {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>().isLoggedIn.value;
    }
    return false;
  }

  /// redirect unauthenticated users to the login screen with a prompt
  void _redirectToLogin() {
    Get.snackbar(
      'Login Required',
      'Please log in to use your cart.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
    Get.toNamed('/auth');
  }

  /// recalculate subtotal and total from current cart items map
  void _recalculate() {
    double sum = 0.0;
    for (final item in _cartItemsMap.values) {
      // prefer priceSnapshot (locked price), fallback to product.price
      final price = item.priceSnapshot > 0
          ? item.priceSnapshot
          : item.product.price;
      sum += price * item.quantity;
    }
    subtotal.value = sum;
    total.value = sum > 0 ? sum + shipping.value : 0.0;
  }

  /// sync the reactive list from the internal map and recalculate totals
  void _updateFromMap() {
    cartItems.assignAll(_cartItemsMap.values.toList());
    _recalculate();
  }

  // ─── api calls ──────────────────────────────────────────────────────────────

  /// fetch cart from api — called on init and manual refresh
  /// shows loading state only on the cart screen
  Future<void> fetchCart() async {
    // skip api call if user is not authenticated — CartScreen shows guest prompt
    if (!_isLoggedIn()) {
      isLoggedIn.value = false;
      status.value = RxStatus.empty();
      return;
    }

    isLoggedIn.value = true;

    status.value = RxStatus.loading();

    final result = await _networkService.get('/cart');

    if (result.isSuccess && result.data != null) {
      try {
        // parse nested response: { success, message, data: { items: [...], subtotal, ... } }
        final Map<String, dynamic> responseData =
            result.data as Map<String, dynamic>;
        final Map<String, dynamic> cartData =
            responseData['data'] as Map<String, dynamic>? ?? {};

        final List<dynamic> itemsList = cartData['items'] as List<dynamic>? ?? [];

        _cartItemsMap.clear();

        for (final itemJson in itemsList) {
          final item = CartItemModel.fromJson(itemJson as Map<String, dynamic>);
          // use the nested product._id as map key
          _cartItemsMap[item.product.id] = item;
        }

        // use server-calculated subtotal if available
        final double serverSubtotal =
            (cartData['subtotal'] as num?)?.toDouble() ?? 0.0;
        if (serverSubtotal > 0) {
          subtotal.value = serverSubtotal;
          total.value = serverSubtotal + shipping.value;
          cartItems.assignAll(_cartItemsMap.values.toList());
        } else {
          _updateFromMap();
        }

        status.value =
            cartItems.isEmpty ? RxStatus.empty() : RxStatus.success();
      } catch (e) {
        debugPrint('CartController: fetchCart parse error: $e');
        status.value =
            cartItems.isEmpty ? RxStatus.empty() : RxStatus.success();
      }
    } else {
      // api failed — keep whatever was in memory
      status.value =
          cartItems.isEmpty ? RxStatus.empty() : RxStatus.success();
    }
  }

  // ─── mutations (all fire-and-forget — no loading shown to user) ─────────────

  /// add product to cart by product id and quantity.
  /// returns true if the item was added (user is logged in),
  /// returns false if user is not logged in (redirected to login screen).
  /// call sites should only show the success snackbar when this returns true.
  bool addToCart(String productId, {int quantity = 1, CartItemModel? optimisticItem}) {
    // guard: redirect guest users to login and signal caller with false
    if (!_isLoggedIn()) {
      _redirectToLogin();
      return false;
    }

    if (_cartItemsMap.containsKey(productId)) {
      // product already in cart — increase quantity instead
      increaseQuantity(productId);
      return true;
    }

    // optimistic add: insert a temporary placeholder while api call runs
    if (optimisticItem != null) {
      _cartItemsMap[productId] = optimisticItem;
      _updateFromMap();
      if (status.value.isEmpty) {
        status.value = RxStatus.success();
      }
    }

    // fire-and-forget: no await
    _networkService.post(
      '/cart/items',
      data: {'productId': productId, 'quantity': quantity},
    ).then((result) {
      if (result.isSuccess) {
        // refresh cart from api to get accurate data with priceSnapshot etc.
        fetchCart();
      } else if (optimisticItem != null) {
        // rollback optimistic update on failure
        _cartItemsMap.remove(productId);
        _updateFromMap();
        if (cartItems.isEmpty) status.value = RxStatus.empty();
      }
    });

    return true;
  }

  /// increase item quantity by 1 (optimistic update, fire-and-forget api)
  void increaseQuantity(String productId) {
    final currentItem = _cartItemsMap[productId];
    if (currentItem == null) return;

    final int newQty = currentItem.quantity + 1;

    // optimistic update immediately
    _cartItemsMap[productId] = CartItemModel(
      product: currentItem.product,
      quantity: newQty,
      priceSnapshot: currentItem.priceSnapshot,
      productSnapshot: currentItem.productSnapshot,
    );
    _updateFromMap();

    // fire-and-forget patch call
    _networkService.patch(
      '/cart/items',
      data: {'productId': productId, 'quantity': newQty},
    ).then((result) {
      if (!result.isSuccess) {
        // rollback on failure
        _cartItemsMap[productId] = currentItem;
        _updateFromMap();
      }
    });
  }

  /// decrease item quantity by 1; removes item if quantity reaches 0
  void decreaseQuantity(String productId) {
    final currentItem = _cartItemsMap[productId];
    if (currentItem == null) return;

    if (currentItem.quantity <= 1) {
      // remove item when quantity hits zero
      removeItem(productId);
      return;
    }

    final int newQty = currentItem.quantity - 1;

    // optimistic update immediately
    _cartItemsMap[productId] = CartItemModel(
      product: currentItem.product,
      quantity: newQty,
      priceSnapshot: currentItem.priceSnapshot,
      productSnapshot: currentItem.productSnapshot,
    );
    _updateFromMap();

    // fire-and-forget patch call
    _networkService.patch(
      '/cart/items',
      data: {'productId': productId, 'quantity': newQty},
    ).then((result) {
      if (!result.isSuccess) {
        // rollback on failure
        _cartItemsMap[productId] = currentItem;
        _updateFromMap();
      }
    });
  }

  /// remove a single product from cart (optimistic, fire-and-forget)
  void removeItem(String productId) {
    final removedItem = _cartItemsMap[productId];
    if (removedItem == null) return;

    // optimistic remove immediately
    _cartItemsMap.remove(productId);
    _updateFromMap();
    if (cartItems.isEmpty) status.value = RxStatus.empty();

    // fire-and-forget delete call
    _networkService.delete('/cart/items/$productId').then((result) {
      if (!result.isSuccess) {
        // rollback on failure
        _cartItemsMap[productId] = removedItem;
        _updateFromMap();
        if (status.value.isEmpty) status.value = RxStatus.success();
      }
    });
  }

  /// clear all cart items (optimistic, fire-and-forget)
  void clearCartList() {
    final backup = Map<String, CartItemModel>.from(_cartItemsMap);

    // optimistic clear immediately
    _cartItemsMap.clear();
    _updateFromMap();
    status.value = RxStatus.empty();

    // fire-and-forget delete call
    _networkService.delete('/cart/clear').then((result) {
      if (!result.isSuccess) {
        // rollback on failure
        _cartItemsMap.addAll(backup);
        _updateFromMap();
        if (cartItems.isNotEmpty) status.value = RxStatus.success();
      }
    });
  }

  /// convenience: check if a specific product is already in cart
  bool isInCart(String productId) => _cartItemsMap.containsKey(productId);
}
