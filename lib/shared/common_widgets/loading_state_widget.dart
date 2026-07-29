import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';

/// reusable loading state indicator widget
class LoadingStateWidget extends StatelessWidget {
  final String loadingMessage;

  const LoadingStateWidget({
    super.key,
    this.loadingMessage = 'Loading, please wait...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/loader.json',
            height: 100.h,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.colorFilter(
                  ['**'],
                  value: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          Text(
            loadingMessage,
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
