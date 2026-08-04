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
                  // if the slide promotional link contains a category slug (starts with 'category'), 
                  // we direct the user to the category page with a formatted name to browse 
                  // items, instead of the product details page.
                  if (slide.clickUrl.startsWith('category')) {
                    final String slug = slide.clickUrl.substring(9);
                    // format category name to title case (e.g. commercial-packaging-equipment -> Commercial Packaging Equipment)
                    final String name = slug
                        .split('-')
                        .map((word) => word.isNotEmpty
                            ? '${word[0].toUpperCase()}${word.substring(1)}'
                            : '')
                        .join(' ');

                    Get.toNamed(
                      AppRoutes.subCategoryProducts,
                      arguments: {
                        'slug': slug,
                        'name': name,
                        'isMainCategory': true,
                      },
                    );
                  } else {
                    Get.toNamed(
                      AppRoutes.productDetails,
                      arguments: {'slug': slide.clickUrl.substring(9)},
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
