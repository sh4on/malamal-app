/// data models for the home screen hero API response
/// endpoint: https://api.malamal.com.bd/api/v1/hero/home
library;

import 'product_model.dart';

// slide model for hero banner carousel
class SlideModel {
  final String image;
  final String imageAlt;
  final String title;
  final String description;
  final String clickUrl;

  const SlideModel({
    required this.image,
    required this.imageAlt,
    required this.title,
    required this.description,
    required this.clickUrl,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      image: json['image'] as String? ?? '',
      imageAlt: json['imageAlt'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      clickUrl: json['clickUrl'] as String? ?? '',
    );
  }
}

// feature model for the 3 small promo banners below the carousel
class FeatureModel {
  final String image;
  final String imageAlt;
  final String title;
  final String description;
  final String clickUrl;

  const FeatureModel({
    required this.image,
    required this.imageAlt,
    required this.title,
    required this.description,
    required this.clickUrl,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      image: json['image'] as String? ?? '',
      imageAlt: json['imageAlt'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      clickUrl: json['clickUrl'] as String? ?? '',
    );
  }
}

// brand model for the top brands horizontal scroll section
class BrandModel {
  final String id;
  final String name;
  final String slug;
  final String? image;

  const BrandModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}

// sub-category model nested inside CategoryModel
class SubCategoryModel {
  final String name;
  final String slug;
  final String? image;
  final String? description;

  const SubCategoryModel({
    required this.name,
    required this.slug,
    this.image,
    this.description,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String?,
      description: json['description'] as String?,
    );
  }
}

// category model for the "shop by category" section
class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? image;
  final String? description;
  final List<SubCategoryModel> subCategories;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.description,
    this.subCategories = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> subCatList =
        json['subCategories'] as List<dynamic>? ?? [];
    return CategoryModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String?,
      description: json['description'] as String?,
      subCategories: subCatList
          .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// hero section model from the API heroSection field
class HeroSectionModel {
  final String id;
  final List<SlideModel> slides;
  final List<FeatureModel> features;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  const HeroSectionModel({
    required this.id,
    required this.slides,
    required this.features,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory HeroSectionModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> slideList = json['slides'] as List<dynamic>? ?? [];
    final List<dynamic> featureList = json['features'] as List<dynamic>? ?? [];
    return HeroSectionModel(
      id: json['_id'] as String? ?? '',
      slides: slideList
          .map((e) => SlideModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: featureList
          .map((e) => FeatureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}

// root home data model wrapping all api response fields
class HomeData {
  final HeroSectionModel heroSection;
  final List<BrandModel> brands;
  final List<CategoryModel> categories;
  final List<ProductModel> featuredProducts;
  final List<ProductModel> latestProducts;

  const HomeData({
    required this.heroSection,
    required this.brands,
    required this.categories,
    required this.featuredProducts,
    required this.latestProducts,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> brandList = json['brands'] as List<dynamic>? ?? [];
    final List<dynamic> categoryList =
        json['categories'] as List<dynamic>? ?? [];
    final List<dynamic> featuredList =
        json['featuredProducts'] as List<dynamic>? ?? [];
    final List<dynamic> latestList =
        json['latestProducts'] as List<dynamic>? ?? [];

    return HomeData(
      heroSection: HeroSectionModel.fromJson(
        json['heroSection'] as Map<String, dynamic>? ?? {},
      ),
      brands: brandList
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: categoryList
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredProducts: featuredList
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      latestProducts: latestList
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
