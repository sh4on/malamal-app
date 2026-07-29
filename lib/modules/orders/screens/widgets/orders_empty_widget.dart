import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// empty orders state shown when logged-in user has no orders yet
class OrdersEmptyWidget extends StatelessWidget {
  const OrdersEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64.w,
            color: AppColors.grey,
          ),
          SizedBox(height: AppDimensions.spaceLG.h),
          const Text(
            AppStrings.ordersEmpty,
            style: TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.bold,
              color: AppColors.greyDark,
            ),
          ),
          SizedBox(height: AppDimensions.spaceSM.h),
          const Text(
            AppStrings.ordersEmptySubtitle,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: AppDimensions.fontMD,
            ),
          ),
        ],
      ),
    );
  }
}
