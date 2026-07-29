import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../controllers/product_details_controller.dart';

/// image carousel widget with page view, dot indicators, and badge overlays
class ProductImageCarouselWidget extends StatelessWidget {
  final List<String> images;
  final String? badge;
  final double? discountPercent;
  final String? youtubeVideoId;

  const ProductImageCarouselWidget({
    super.key,
    required this.images,
    this.badge,
    this.discountPercent,
    this.youtubeVideoId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();
    final hasVideo = youtubeVideoId != null && youtubeVideoId!.isNotEmpty;
    final itemCount = images.length + (hasVideo ? 1 : 0);

    return Stack(
      children: [
        // image page view carousel
        SizedBox(
          height: AppDimensions.productImageHeight.h,
          child: PageView.builder(
            itemCount: itemCount,
            onPageChanged: controller.onImagePageChanged,
            itemBuilder: (context, index) {
              final isVideo = hasVideo && index == 0;
              final imageIndex = hasVideo ? index - 1 : index;

              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLG.w,
                  vertical: AppDimensions.spaceSM.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  border: Border.all(color: AppColors.greyBorder, width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  child: isVideo
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg',
                              memCacheHeight: 600,
                              memCacheWidth: 600,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: AppColors.grey,
                                      size: 48,
                                    ),
                                  ),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  // 3-tier fallback for maximum device compatibility
                                  // (same pattern used for WhatsApp to handle OEM restrictions)

                                  // tier 1: vnd.youtube deep link — opens directly in the
                                  // YouTube app, bypasses browser on all android OEMs
                                  // (Vivo Funtouch OS, MIUI, Samsung OneUI, etc.)
                                  final Uri youtubeAppUri = Uri.parse(
                                    'vnd.youtube:$youtubeVideoId',
                                  );

                                  // tier 2: https://youtu.be short link with external app mode
                                  final Uri youtubeShortUri = Uri.parse(
                                    'https://youtu.be/$youtubeVideoId',
                                  );

                                  // tier 3: full youtube.com URL as last resort
                                  final Uri youtubeWebUri = Uri.parse(
                                    'https://www.youtube.com/watch?v=$youtubeVideoId',
                                  );

                                  // try youtube app deep link first
                                  try {
                                    final bool canDirect = await canLaunchUrl(youtubeAppUri);
                                    if (canDirect) {
                                      await launchUrl(
                                        youtubeAppUri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                      return;
                                    }
                                  } catch (_) {}

                                  // fallback to youtu.be short url
                                  try {
                                    final bool launched = await launchUrl(
                                      youtubeShortUri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                    if (launched) return;
                                  } catch (_) {}

                                  // last resort: full youtube url with platform default handler
                                  try {
                                    await launchUrl(
                                      youtubeWebUri,
                                      mode: LaunchMode.platformDefault,
                                    );
                                  } catch (_) {}
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.black.withValues(
                                      alpha: 0.5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    size: 48,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : CachedNetworkImage(
                          imageUrl: images[imageIndex],
                          memCacheHeight: 600,
                          memCacheWidth: 600,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.grey,
                              size: 48,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),

        // badge overlay (e.g. "Hot")
        if (badge != null && badge!.isNotEmpty)
          Positioned(
            top: AppDimensions.spaceLG.h,
            left: AppDimensions.spaceLG.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSM.w,
                vertical: AppDimensions.spaceXS.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: AppDimensions.fontSM,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // discount percentage overlay
        if (discountPercent != null && discountPercent! > 0)
          Positioned(
            top: AppDimensions.space48.h,
            left: AppDimensions.spaceLG.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSM.w,
                vertical: AppDimensions.spaceXS.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.discount,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              ),
              child: Text(
                '-${discountPercent!.round()}%',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: AppDimensions.fontSM,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // dot indicators at the bottom of the carousel
        if (itemCount > 1)
          Positioned(
            bottom: AppDimensions.spaceMD.h,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  itemCount,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceXXS.w,
                    ),
                    width: controller.selectedImageIndex.value == index
                        ? AppDimensions.spaceXL.w
                        : AppDimensions.dotIndicatorSize.w,
                    height: AppDimensions.dotIndicatorSize.h,
                    decoration: BoxDecoration(
                      color: controller.selectedImageIndex.value == index
                          ? AppColors.primary
                          : AppColors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusRound,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
