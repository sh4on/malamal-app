import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/network_service.dart';
import '../../../core/utils/mixins/pagination_mixin.dart';
import '../../../data/models/product_model.dart';

/// search query and autocomplete listings controller
class SearchController extends GetxController with PaginationMixin {
  final NetworkService _networkService = NetworkService.instance;

  // rx status for loading/error/success states
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.empty());

  // search text field controller
  final TextEditingController searchTextController = TextEditingController();

  // dynamic autocomplete list suggestions
  final RxList<ProductModel> suggestions = <ProductModel>[].obs;

  // active search results items grid
  final RxList<ProductModel> results = <ProductModel>[].obs;

  // active search input flag for display autocomplete overlay
  final RxBool showAutocomplete = false.obs;

  // tracking query string
  final RxString currentQuery = ''.obs;

  // flag indicating if search submission has occurred
  final RxBool isSearchSubmitted = false.obs;

  // dynamic search results statistics count text
  final RxString statsText = 'Enter a search term'.obs;

  Timer? _debounce;
  bool hasNextPage = true;

  @override
  void onInit() {
    super.onInit();
    
    initPagination(() {
      if (hasNextPage && !isLock && !status.value.isLoadingMore) {
        _fetchSearchResults(isLoadMore: true);
      }
    });
  }

  /// update search text and filter suggestions list
  void updateQuery(String query) {
    currentQuery.value = query;
    if (query.trim().isEmpty) {
      showAutocomplete.value = false;
      suggestions.clear();
      results.clear();
      isSearchSubmitted.value = false;
      status.value = RxStatus.empty();
      statsText.value = 'Enter a search term';
    }
  }

  /// trigger search query submit and display full results list
  void submitSearch(String query) {
    searchTextController.text = query;
    currentQuery.value = query;
    showAutocomplete.value = false;
    suggestions.clear();

    if (query.trim().isEmpty) {
      results.clear();
      isSearchSubmitted.value = false;
      status.value = RxStatus.empty();
      statsText.value = 'Enter a search term';
      return;
    }

    isSearchSubmitted.value = true;
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults({bool isLoadMore = false}) async {
    if (isLoadMore) {
      status.value = RxStatus.loadingMore();
      currentPage++;
    } else {
      status.value = RxStatus.loading();
      currentPage = 1;
      results.clear();
      hasNextPage = true;
    }
    
    isLock = true;
    
    final endpoint = 'https://api.malamal.com.bd/api/v1/product/all?limit=$limit&page=$currentPage&searchTerm=${currentQuery.value}';
    final networkResult = await _networkService.get(endpoint);

    if (networkResult.isSuccess) {
      final List data = networkResult.data?['data'] ?? [];
      final int totalPages = networkResult.data?['meta']?['totalPages'] ?? 1;
      final int totalResults = networkResult.data?['meta']?['total'] ?? 0;
      
      final List<ProductModel> newProducts = data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (isLoadMore) {
        results.addAll(newProducts);
      } else {
        results.assignAll(newProducts);
      }
      
      hasNextPage = currentPage < totalPages;

      if (results.isEmpty) {
        status.value = RxStatus.empty();
      } else {
        status.value = RxStatus.success();
      }
      
      statsText.value = "Showing all $totalResults results for '${currentQuery.value}'";
    } else {
      status.value = RxStatus.error(networkResult.message);
      if (isLoadMore) {
        currentPage--;
      }
    }
    
    isLock = false;
  }
  
  void retry() {
    if (currentQuery.value.isNotEmpty) {
      _fetchSearchResults();
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchTextController.dispose();
    disposePagination();
    super.onClose();
  }
}

