import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/profile_controller.dart';
import 'widgets/account_info_detail_card.dart';

/// screen displaying logged-in user account details
class AccountInformationScreen extends GetView<ProfileController> {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text(
          AppStrings.accountInformation,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              Get.defaultDialog(
                title: 'Update Profile',
                titleStyle: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
                middleText:
                    'Please visit www.malamal.com.bd to update your profile.',
                middleTextStyle: const TextStyle(color: AppColors.greyDark),
                textConfirm: 'OK',
                confirmTextColor: AppColors.white,
                buttonColor: AppColors.primary,
                onConfirm: () => Get.back(),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.userProfile.value;

        // handle empty profile state
        if (user == null) {
          return const Center(
            child: Text(
              'No profile information found.',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: AppDimensions.fontMD,
              ),
            ),
          );
        }

        final String displayName = user.name;
        final String displayEmail = user.email;
        final String displayPhone = user.phone ?? 'N/A';
        final String displayDob = user.dob ?? 'N/A';
        final String displayRole = user.role ?? 'USER';
        final String? avatarUrl = user.profilePhoto;

        return SingleChildScrollView(
          child: Column(
            children: [
              // avatar and name banner section
              Container(
                color: AppColors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceXXL.h,
                ),
                child: Column(
                  children: [
                    // profile picture with cached network image or fallback initial
                    if (avatarUrl != null && avatarUrl.isNotEmpty)
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: avatarUrl,
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                          memCacheWidth: 160,
                          memCacheHeight: 160,
                          placeholder: (context, url) => Container(
                            width: 80.w,
                            height: 80.w,
                            color: AppColors.greyLight,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 40.r,
                            backgroundColor: AppColors.primary.withOpacity(
                              0.12,
                            ),
                            child: Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: AppDimensions.space32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: AppColors.primary.withOpacity(0.12),
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: AppDimensions.space32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    SizedBox(height: AppDimensions.spaceMD.h),
                    // user display name
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spaceMD.h),

              // detailed information card section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLG.w,
                ),
                child: AccountInfoDetailCard(
                  name: displayName,
                  email: displayEmail,
                  phone: displayPhone,
                  dob: displayDob,
                  role: displayRole,
                ),
              ),
              SizedBox(height: AppDimensions.spaceXXL.h),
            ],
          ),
        );
      }),
    );
  }
}
