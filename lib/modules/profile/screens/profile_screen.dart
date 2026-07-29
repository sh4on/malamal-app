import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'widgets/profile_guest_widget.dart';
import 'widgets/profile_dashboard_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// user account screen — shows guest panel or logged-in dashboard
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // manually inject controller if not registered
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text(
          AppStrings.myProfile,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Obx(() {
        // loading spinner while checking auth state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // show guest prompt if user is not logged in
        if (!controller.isLoggedIn.value) {
          return const ProfileGuestWidget();
        }

        // show logged-in user dashboard
        final user = controller.userProfile.value;
        return ProfileDashboardWidget(
          displayName: user?.name ?? 'Malamal Customer',
          displayEmail: user?.email ?? '',
          displayPhone: user?.phone ?? '',
          onLogout: controller.logout,
        );
      }),
    );
  }
}
