/// catalog product data model
class ProductModel {
  final String id;
  final String name;
  final String slug;
  final String sku;
  final String? description;
  final String imageUrl;
  final double price;
  final double? oldPrice; // for displaying discount/strike-through
  final double rating;
  final String? brand;
  final String? category;
  final bool inStock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.sku,
    this.description,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    this.rating = 0.0,
    this.brand,
    this.category,
    this.inStock = true,
  });

  /// map json map data to ProductModel instance
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? json['title'] ?? '',
      slug: json['slug'] ?? '',
      sku: json['sku'] ?? '',
      description: json['description'],
      imageUrl: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0]
          : json['imageUrl'] ?? json['image'] ?? 'https://picsum.photos/200',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      brand: json['brand'] is Map
          ? json['brand']['name']
          : json['brand'] as String?,
      category: json['category'] is Map
          ? json['category']['name']
          : json['category'] as String?,
      inStock: json['inStock'] ?? true,
    );
  }

  /// serialize ProductModel to json map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'oldPrice': oldPrice,
      'rating': rating,
      'brand': brand,
      'category': category,
      'inStock': inStock,
    };
  }
}
