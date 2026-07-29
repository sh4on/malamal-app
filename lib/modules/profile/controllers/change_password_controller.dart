import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/network_service.dart';
import '../../../core/constants/app_colors.dart';
import 'profile_controller.dart';

/// controller managing inputs and API operations for change password flow
class ChangePasswordController extends GetxController {
  final NetworkService _networkService = NetworkService.instance;

  // text input fields controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // form validation state key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // active operations loading state
  final RxBool isLoading = false.obs;

  // password visibility toggling states
  final RxBool isOldPasswordObscure = true.obs;
  final RxBool isNewPasswordObscure = true.obs;
  final RxBool isConfirmPasswordObscure = true.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// validate input states and dispatch patch API call
  Future<void> submitChangePassword() async {
    // hide keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.validate()) return;

    final String oldPassword = oldPasswordController.text;
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // confirm match validation check
    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'New passwords do not match!',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    isLoading.value = true;

    // execute patch API request
    final result = await _networkService.patch(
      '/user/change-password',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );

    isLoading.value = false;

    if (result.isSuccess) {
      // update active auth tokens on success
      final String? newToken = result.data?['data']?['accessToken'];
      if (newToken != null && newToken.isNotEmpty) {
        _networkService.setToken(newToken);
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().token.value = newToken;
        }
        try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', newToken);
        } catch (_) {}
      }

      // clean input values on success
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // navigate back first, then display snackbar
      Get.back();

      Get.snackbar(
        'Success',
        result.message ?? 'Password changed successfully!',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        result.message ?? 'Failed to change password. Please try again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
  }
}
