import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_api.dart';
import '../../../core/services/network_service.dart';
import '../../../data/models/home_model.dart';
import '../../../data/models/product_model.dart';

/// home screen controller fetching real data from malamal hero/home API
class HomeController extends GetxController {
  // rx status for loading/error/success states
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());

  // scaffold key for the home screen (which holds the endDrawer)
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // reactive slides list for the hero banner carousel
  final RxList<SlideModel> slides = <SlideModel>[].obs;

  // reactive feature banners list (3 promo tiles below carousel)
  final RxList<FeatureModel> features = <FeatureModel>[].obs;

  // reactive categories list for the "shop by category" section
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  // reactive brands list for the horizontal brand scroll
  final RxList<BrandModel> brands = <BrandModel>[].obs;

  // featured and latest products (mock until product api is provided)
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> latestProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // fetch real home data on controller initialization
    fetchHomeData();
  }

  /// fetch all home page data from the API
  Future<void> fetchHomeData() async {
    status.value = RxStatus.loading();

    final result = await NetworkService.instance.get(AppApi.heroHome);

    if (result.isSuccess && result.data != null) {
      try {
        // parse the nested data object from api response
        final Map<String, dynamic> responseMap =
            result.data as Map<String, dynamic>;
        final Map<String, dynamic>? dataMap =
            responseMap['data'] as Map<String, dynamic>?;

        if (dataMap == null) {
          status.value = RxStatus.error('Invalid response from server.');
          return;
        }

        // parse home data from api response
        final HomeData homeData = HomeData.fromJson(dataMap);

        // populate reactive lists
        slides.assignAll(homeData.heroSection.slides);
        features.assignAll(homeData.heroSection.features);
        brands.assignAll(homeData.brands);
        categories.assignAll(homeData.categories);
        featuredProducts.assignAll(homeData.featuredProducts);
        latestProducts.assignAll(homeData.latestProducts);

        if (slides.isEmpty && categories.isEmpty) {
          status.value = RxStatus.empty();
        } else {
          status.value = RxStatus.success();
        }
      } catch (e) {
        status.value = RxStatus.error('Failed to parse home data.');
      }
    } else {
      status.value = RxStatus.error(
        result.message ?? 'Failed to load home content.',
      );
    }
  }
}
