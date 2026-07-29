import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../controllers/product_details_controller.dart';

/// quantity selector widget with increment/decrement buttons and quantity display
class ProductQuantitySelectorWidget extends StatelessWidget {
  final String sellingUnit;

  const ProductQuantitySelectorWidget({
    super.key,
    required this.sellingUnit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG.w,
      ),
      child: Row(
        children: [
          // quantity label
          const Text(
            'Quantity',
            style: TextStyle(
              fontSize: AppDimensions.fontMD,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(width: AppDimensions.spaceLG.w),

          // quantity controls container
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyBorder),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // decrement button
                _buildQuantityButton(
                  icon: Icons.remove,
                  onPressed: controller.decrementQty,
                ),

                // quantity display
                Obx(
                  () => Container(
                    constraints: BoxConstraints(minWidth: 40.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSM.w,
                    ),
                    child: Text(
                      '${controller.quantity.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontLG,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),

                // increment button
                _buildQuantityButton(
                  icon: Icons.add,
                  onPressed: controller.incrementQty,
                ),
              ],
            ),
          ),

          SizedBox(width: AppDimensions.spaceSM.w),

          // selling unit label
          Text(
            sellingUnit,
            style: const TextStyle(
              fontSize: AppDimensions.fontSM,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// helper to build quantity increment/decrement icon buttons
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceSM.w),
        child: Icon(
          icon,
          size: AppDimensions.iconMD,
          color: AppColors.greyDark,
        ),
      ),
    );
  }
}
