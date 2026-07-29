import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// delivery options card displaying pickup and courier delivery details
class ProductDeliveryOptionsWidget extends StatelessWidget {
  const ProductDeliveryOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.greyLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(color: AppColors.greyBorder, width: 0.5),
        ),
        child: Column(
          children: [
            // pickup option row
            _buildDeliveryOptionRow(
              icon: Icons.inventory_2_outlined,
              title: 'Pick up from the Malamal Warehouse',
              subtitle: 'To pick up today',
              trailing: 'Free',
            ),
            
            // courier option row
            _buildDeliveryOptionRow(
              icon: Icons.local_shipping_outlined,
              title: 'Courier / Agent delivery',
              subtitle: 'Delivery agent will deliver to the specified address.',
              trailing: '2-3 Days',
            ),
          ],
        ),
      ),
    );
  }

  /// helper to build each row in the delivery options card
  Widget _buildDeliveryOptionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG.w,
        vertical: AppDimensions.spaceMD.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icon
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppDimensions.iconLG,
            ),
          ),
          SizedBox(width: AppDimensions.spaceMD.w),
          
          // title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontMD,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXXS.h),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSM,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.spaceMD.w),
          
          // trailing info (e.g. Free, 2-3 Days)
          Text(
            trailing,
            style: const TextStyle(
              fontSize: AppDimensions.fontMD,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
