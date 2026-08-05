import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// features card widget that displays html features string
class ProductFeaturesWidget extends StatelessWidget {
  final String featuresHtml;

  const ProductFeaturesWidget({super.key, required this.featuresHtml});

  @override
  Widget build(BuildContext context) {
    // build the features section with formatted title and custom styled html list inside a decorated card
    if (featuresHtml.isEmpty) return const SizedBox.shrink();

    final String cleanedFeaturesHtml = _cleanHtml(featuresHtml);

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
              data: cleanedFeaturesHtml,
              style: {
                // base body style inside the specifications card
                'body': Style(
                  fontSize: FontSize(AppDimensions.fontMD),
                  color: AppColors.black,
                  lineHeight: const LineHeight(1.5),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                // reset default list margins and paddings to prevent extra vertical gaps at the start and end of the list
                'ul': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                // remove top and bottom margins of list items to eliminate empty vertical lines between the specs
                'li': Style(margin: Margins.only(top: 0, bottom: 0)),
                'b': Style(fontWeight: FontWeight.w600),
                'strong': Style(fontWeight: FontWeight.w600),
              },
            ),
          ),
        ],
      ),
    );
  }

  /// clean features html content to remove inline line-height and redundant spacing
  String _cleanHtml(String html) {
    // strip out inline line-height to avoid flutter_html misinterpreting units as raw multipliers, and clean empty structures
    if (html.isEmpty) return html;

    // remove inline line-height styles because flutter_html incorrectly parses line-height with units (like 25px) as raw multipliers, causing massive vertical layout gaps
    final String cleanedLineHeight = html.replaceAll(
      RegExp(r'line-height\s*:\s*[^;"]+;?', caseSensitive: false),
      '',
    );

    // replace empty/whitespace paragraph tags with empty string to avoid rendering empty lines
    final String cleanedParagraphs = cleanedLineHeight.replaceAll(
      RegExp(r'<p>\s*(?:&nbsp;|<br\s*\/?>|\s)*\s*</p>', caseSensitive: false),
      '',
    );

    // replace multiple consecutive br tags with a single br tag to keep the layout compact
    final String cleanedBreaks = cleanedParagraphs.replaceAll(
      RegExp(r'(?:<br\s*\/?>\s*){2,}', caseSensitive: false),
      '<br/>',
    );

    return cleanedBreaks.trim();
  }
}
