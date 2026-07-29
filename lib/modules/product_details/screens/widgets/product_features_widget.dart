import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// features card widget that displays html features string
class ProductFeaturesWidget extends StatelessWidget {
  final String featuresHtml;

  const ProductFeaturesWidget({
    super.key,
    required this.featuresHtml,
  });

  @override
  Widget build(BuildContext context) {
    if (featuresHtml.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // section title
          const Text(
            AppStrings.features,
            style: TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: AppDimensions.spaceMD.h),

          // specifications card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.spaceSM.w),
            decoration: BoxDecoration(
              color: AppColors.greyLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              border: Border.all(color: AppColors.greyBorder, width: 0.5),
            ),
            child: Html(
              data: featuresHtml,
              style: {
                'body': Style(
                  fontSize: FontSize(AppDimensions.fontMD),
                  color: AppColors.black,
                  lineHeight: const LineHeight(1.5),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                'b': Style(fontWeight: FontWeight.w600),
                'strong': Style(fontWeight: FontWeight.w600),
              },
            ),
          ),
        ],
      ),
    );
  }
}
