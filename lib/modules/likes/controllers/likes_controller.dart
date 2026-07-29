import 'package:get/get.dart';

/// likes/wishlist controller managing saved item listings
class LikesController extends GetxController {
  // wishlist item count state
  final RxList<String> wishlistItems = <String>[].obs;

  /// add or remove item from wishlist
  void toggleWishlist(String itemId) {
    if (wishlistItems.contains(itemId)) {
      wishlistItems.remove(itemId);
    } else {
      wishlistItems.add(itemId);
    }
  }
}
