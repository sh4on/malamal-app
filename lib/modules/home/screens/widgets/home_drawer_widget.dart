import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Drawer widget containing quick links to website policies and contacts
class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppDimensions.spaceLG.h),
            Image.asset('assets/logo.webp', height: 40.h),
            SizedBox(height: AppDimensions.spaceLG.h),
            const Divider(color: AppColors.greyLight),
            _buildDrawerItem(
              title: 'Our Contacts',
              icon: CupertinoIcons.phone,
              onTap: () => _launchUrl('https://malamal.com.bd/our-contacts'),
            ),
            _buildDrawerItem(
              title: 'About Us',
              icon: CupertinoIcons.info_circle,
              onTap: () => _launchUrl('https://malamal.com.bd/about-us'),
            ),
            _buildDrawerItem(
              title: 'Privacy Policy',
              icon: CupertinoIcons.shield,
              onTap: () => _launchUrl('https://malamal.com.bd/privacy-policy'),
            ),
            _buildDrawerItem(
              title: 'Terms & Conditions',
              icon: CupertinoIcons.doc_text,
              onTap: () =>
                  _launchUrl('https://malamal.com.bd/terms-and-conditions'),
            ),
            _buildDrawerItem(
              title: 'Return Policy',
              icon: CupertinoIcons.arrow_uturn_left,
              onTap: () => _launchUrl('https://malamal.com.bd/return-policy'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.black,
          fontSize: AppDimensions.fontMD.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
