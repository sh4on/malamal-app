import 'package:get/get.dart';

/// global app state controller
class AppController extends GetxController {
  // tracking system dark theme status
  final RxBool isDarkTheme = false.obs;

  /// switch light/dark theme preference
  void toggleTheme() {
    isDarkTheme.toggle();
  }
}
