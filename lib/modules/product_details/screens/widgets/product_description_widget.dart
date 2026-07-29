import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// product description widget that renders html content fully at once
class ProductDescriptionWidget extends StatelessWidget {
  final String descriptionHtml;

  const ProductDescriptionWidget({
    super.key,
    required this.descriptionHtml,
  });

  @override
  Widget build(BuildContext context) {
    if (descriptionHtml.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // section title header
          const Text(
            AppStrings.description,
            style: TextStyle(
              fontSize: AppDimensions.fontLG,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: AppDimensions.spaceMD.h),

          // show full html content at once without expand limits
          _buildHtmlContent(),
        ],
      ),
    );
  }

  /// build the html rendered content widget with local stylesheets
  Widget _buildHtmlContent() {
    return Html(
      data: descriptionHtml,
      style: {
        // base body styling
        'body': Style(
          fontSize: FontSize(AppDimensions.fontMD),
          color: AppColors.greyDark,
          lineHeight: const LineHeight(1.6),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        // heading styles
        'h2': Style(
          fontSize: FontSize(AppDimensions.fontLG),
          fontWeight: FontWeight.w700,
          color: AppColors.black,
          margin: Margins.only(
            top: AppDimensions.spaceLG,
            bottom: AppDimensions.spaceSM,
          ),
        ),
        'h3': Style(
          fontSize: FontSize(AppDimensions.fontMD),
          fontWeight: FontWeight.w600,
          color: AppColors.black,
          margin: Margins.only(
            top: AppDimensions.spaceMD,
            bottom: AppDimensions.spaceXS,
          ),
        ),
        // paragraph style
        'p': Style(
          fontSize: FontSize(AppDimensions.fontMD),
          color: AppColors.greyDark,
          lineHeight: const LineHeight(1.6),
          margin: Margins.only(bottom: AppDimensions.spaceMD),
        ),
        // bold text styles
        'b': Style(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        'strong': Style(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        // list styles
        'ul': Style(
          margin: Margins.only(
            left: AppDimensions.spaceSM,
            bottom: AppDimensions.spaceMD,
          ),
        ),
        'li': Style(
          fontSize: FontSize(AppDimensions.fontMD),
          color: AppColors.greyDark,
          lineHeight: const LineHeight(1.6),
          margin: Margins.only(bottom: AppDimensions.spaceXS),
        ),
        // table styles
        'table': Style(
          border: Border.all(color: AppColors.greyBorder, width: 0.5),
        ),
        'td': Style(
          fontSize: FontSize(AppDimensions.fontSM),
          padding: HtmlPaddings.all(AppDimensions.spaceSM),
          border: Border.all(color: AppColors.greyBorder, width: 0.5),
        ),
      },
    );
  }
}
