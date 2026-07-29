import 'package:flutter/material.dart';

mixin PaginationMixin {
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  int limit = 10;
  bool isLock = false;

  void initPagination(VoidCallback onScrollEnd) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        onScrollEnd();
      }
    });
  }

  void disposePagination() {
    scrollController.dispose();
  }
}
