import 'package:get/get.dart';
import '../../../data/models/home_model.dart';
import '../../../modules/home/controllers/home_controller.dart';

/// categories controller — shares category data loaded by home controller
class CategoriesController extends GetxController {
  // reactive list of all categories from home api
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());

  @override
  void onInit() {
    super.onInit();
    // load categories data from home controller if already available
    syncFromHomeController();
  }

  /// sync categories from home controller to avoid duplicate api calls
  void syncFromHomeController() {
    // try to get categories from existing home controller
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      // wait for home data to be ready
      if (homeController.categories.isNotEmpty) {
        categories.assignAll(homeController.categories);
        status.value = RxStatus.success();
      } else {
        // listen for when home controller finishes loading
        ever(homeController.categories, (List<CategoryModel> cats) {
          if (cats.isNotEmpty) {
            categories.assignAll(cats);
            status.value = RxStatus.success();
          }
        });

        // mirror the loading/error status from home controller
        ever(homeController.status, (RxStatus s) {
          if (s.isError) {
            status.value = RxStatus.error(s.errorMessage);
          } else if (s.isLoading) {
            status.value = RxStatus.loading();
          }
        });
      }
    } else {
      status.value = RxStatus.empty();
    }
  }
}
