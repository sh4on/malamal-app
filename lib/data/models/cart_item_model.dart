import 'product_model.dart';

/// snapshot data embedded inside each cart item from the api response
class CartItemProductSnapshot {
  final String title;
  final String brand;
  final String category;
  final String categorySlug;
  final String image;
  final String sku;
  final String slug;
  final double price;
  final String sellingUnit;
  final int stock;
  final double weightKg;
  final bool isNoCOD;

  const CartItemProductSnapshot({
    required this.title,
    required this.brand,
    required this.category,
    required this.categorySlug,
    required this.image,
    required this.sku,
    required this.slug,
    required this.price,
    required this.sellingUnit,
    required this.stock,
    required this.weightKg,
    required this.isNoCOD,
  });

  /// map json to CartItemProductSnapshot
  factory CartItemProductSnapshot.fromJson(Map<String, dynamic> json) {
    return CartItemProductSnapshot(
      title: json['title'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      categorySlug: json['categorySlug'] as String? ?? '',
      image: json['image'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sellingUnit: json['sellingUnit'] as String? ?? 'pcs',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
      isNoCOD: json['isNoCOD'] as bool? ?? false,
    );
  }
}

/// cart item wrapper holding product data, quantity, and snapshots from api
class CartItemModel {
  /// full product object returned nested in each cart item
  final ProductModel product;

  /// item count selected by the user
  final int quantity;

  /// price locked at the time of adding to cart
  final double priceSnapshot;

  /// lightweight product snapshot for display without extra joins
  final CartItemProductSnapshot? productSnapshot;

  const CartItemModel({
    required this.product,
    required this.quantity,
    this.priceSnapshot = 0.0,
    this.productSnapshot,
  });

  /// map api json (single item entry inside data.items[]) to CartItemModel
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // parse nested product object
    final productJson = json['product'] as Map<String, dynamic>? ?? {};

    // parse optional productSnapshot
    final snapshotJson = json['productSnapshot'] as Map<String, dynamic>?;
    final snapshot =
        snapshotJson != null ? CartItemProductSnapshot.fromJson(snapshotJson) : null;

    return CartItemModel(
      product: ProductModel.fromJson(productJson),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      priceSnapshot: (json['priceSnapshot'] as num?)?.toDouble() ?? 0.0,
      productSnapshot: snapshot,
    );
  }
}
