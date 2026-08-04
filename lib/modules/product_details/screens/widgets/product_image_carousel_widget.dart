import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
                            // high quality youtube thumbnail
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

                            // play button overlay with circular semi-transparent container
                            Center(
                              child: InkWell(
                                onTap: () => _showVideoPopup(context, youtubeVideoId!),
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

  /// show a dialog containing the youtube player with custom styles
  void _showVideoPopup(BuildContext context, String videoId) {
    // create the controller locally for the popup dialog lifecycle so it automatically
    // disposes when the popup is dismissed to prevent memory leaks.
    final YoutubePlayerController youtubeController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: false,
        showControls: true,
        mute: false,
        showVideoAnnotations: false,
      ),
    );

    // display the custom dialog holding the video player
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLG.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // close button positioned above the video card for clear dismissal option
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.white,
                  size: AppDimensions.iconXL,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            SizedBox(height: AppDimensions.spaceSM.h),

            // rounded container holding the youtube player
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
              child: YoutubePlayer(
                controller: youtubeController,
                aspectRatio: 16 / 9,
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      // dispose player controller to release resource memory once popup goes away
      youtubeController.close();
    });
  }
}
