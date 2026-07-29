/// product details data model for full product detail api response
class ProductDetailsModel {
  final String id;
  final String title;
  final String slug;
  final String sku;
  final List<String> images;
  final String features;
  final String description;
  final double price;
  final double? oldPrice;
  final ProductBrandModel? brand;
  final ProductCategoryModel? category;
  final String? subCategorySlug;
  final double? weightKg;
  final double rating;
  final String? badge;
  final String? youtubeVideoId;
  final String sellingUnit;
  final bool isFeatured;
  final bool isNoCOD;
  final bool isActive;
  final bool inStock;

  const ProductDetailsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.sku,
    required this.images,
    required this.features,
    required this.description,
    required this.price,
    this.oldPrice,
    this.brand,
    this.category,
    this.subCategorySlug,
    this.weightKg,
    this.rating = 0.0,
    this.badge,
    this.youtubeVideoId,
    this.sellingUnit = 'pcs',
    this.isFeatured = false,
    this.isNoCOD = false,
    this.isActive = true,
    this.inStock = true,
  });

  /// compute discount percentage if old price exists
  double get discountPercent {
    if (oldPrice == null || oldPrice == 0) return 0.0;
    return ((oldPrice! - price) / oldPrice! * 100);
  }

  /// map json data to ProductDetailsModel instance
  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // parse images list
    final List<String> imageList = [];
    if (json['images'] != null && json['images'] is List) {
      for (final img in json['images']) {
        imageList.add(img.toString());
      }
    }

    return ProductDetailsModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      slug: json['slug'] ?? '',
      sku: json['sku'] ?? '',
      images: imageList,
      features: json['features'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      brand: json['brand'] is Map<String, dynamic>
          ? ProductBrandModel.fromJson(json['brand'])
          : null,
      category: json['category'] is Map<String, dynamic>
          ? ProductCategoryModel.fromJson(json['category'])
          : null,
      subCategorySlug: json['subCategorySlug'],
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      badge: json['badge'],
      youtubeVideoId: json['youtubeVideoId'],
      sellingUnit: json['sellingUnit'] ?? 'pcs',
      isFeatured: json['isFeatured'] ?? false,
      isNoCOD: json['isNoCOD'] ?? false,
      isActive: json['isActive'] ?? true,
      // null stock means in stock
      inStock: json['stock'] != null ? (json['stock'] as num) > 0 : true,
    );
  }
}

/// nested brand model for product details
class ProductBrandModel {
  final String id;
  final String name;
  final String slug;

  const ProductBrandModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  /// map json to ProductBrandModel
  factory ProductBrandModel.fromJson(Map<String, dynamic> json) {
    return ProductBrandModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

/// nested category model for product details
class ProductCategoryModel {
  final String id;
  final String name;
  final String slug;

  const ProductCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  /// map json to ProductCategoryModel
  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
