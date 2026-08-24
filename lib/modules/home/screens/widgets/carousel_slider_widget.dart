import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:project_m/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../data/models/home_model.dart';

/// hero banner carousel widget with auto-scroll and dot indicators
class CarouselSliderWidget extends StatefulWidget {
  final List<SlideModel> slides;

  const CarouselSliderWidget({super.key, required this.slides});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  // current active page index for dot indicator
  int _currentIndex = 0;
  late final PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // start auto-scroll timer after brief delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// start the auto-scroll timer to cycle through slides every 4 seconds
  void _startAutoScroll() {
    if (widget.slides.length <= 1) return;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final int nextIndex = (_currentIndex + 1) % widget.slides.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // banner page view container
        SizedBox(
          height: AppDimensions.bannerHeight.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: widget.slides.length,
            itemBuilder: (context, index) {
              final slide = widget.slides[index];
              return GestureDetector(
                onTap: () {
                  // parse the clickUrl as a URI to safely extract path segments
                  // this handles both full URLs (https://malamal.com.bd/product/...)
                  // and relative paths (product/...) without fragile substring offsets
                  final Uri uri = Uri.parse(slide.clickUrl);
                  final List<String> segments = uri.pathSegments;

                  if (segments.isEmpty) return;

                  // first path segment indicates the type: 'category' or 'product'
                  final String type = segments.first;

                  if (type == 'category') {
                    // url shape: /category/{parentSlug}/{subSlug}
                    // target slug is always the last segment
                    final String targetSlug = segments.last;

                    // isMain = true only when there is no sub-category segment
                    // e.g. /category/welding-cutting → isMain (2 segments incl. 'category')
                    // e.g. /category/welding-cutting/welding-machine → sub-category (3 segments)
                    final bool isMain = segments.length == 2;

                    // format slug to title case for the screen title
                    final String name = targetSlug
                        .split('-')
                        .map(
                          (word) => word.isNotEmpty
                              ? '${word[0].toUpperCase()}${word.substring(1)}'
                              : '',
                        )
                        .join(' ');

                    debugPrint(
                      '[Carousel] category slug: $targetSlug (isMain: $isMain)',
                    );

                    Get.toNamed(
                      AppRoutes.subCategoryProducts,
                      arguments: {
                        'slug': targetSlug,
                        'name': name,
                        'isMainCategory': isMain,
                      },
                    );
                  } else {
                    // product link: slug is always the last path segment
                    final String productSlug = segments.last;

                    debugPrint('[Carousel] product slug: $productSlug');

                    Get.toNamed(
                      AppRoutes.productDetails,
                      arguments: {'slug': productSlug},
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceLG.w,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMD.r,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: slide.image,
                      memCacheHeight: 360,
                      memCacheWidth: 720,
                      fit: BoxFit.cover,
                      // loading placeholder with shimmer effect
                      placeholder: (context, url) => Container(
                        color: AppColors.shimmer,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.greyLight,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppDimensions.spaceSM.h),
        // dot page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _currentIndex == index ? 20.w : 6.w,
              height: 6.h,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusRound.r,
                ),
                color: _currentIndex == index
                    ? AppColors.primary
                    : AppColors.grey.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
