import 'package:get/get.dart';
import '../controllers/search_controller.dart' as app_search;

/// search module bindings setup
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<app_search.SearchController>(() => app_search.SearchController());
  }
}
