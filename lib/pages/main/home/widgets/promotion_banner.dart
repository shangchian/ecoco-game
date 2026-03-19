import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '/models/carousel_model.dart';
import '/utils/snackbar_helper.dart';
import '/providers/carousel_provider.dart';
import '/constants/carousel_constants.dart';
import '/widgets/video_player_dialog.dart';
import '/services/deep_link/link_parser.dart';
import '/router/deep_link_router.dart';

class PromotionBanner extends ConsumerStatefulWidget {
  const PromotionBanner({super.key});

  @override
  ConsumerState<PromotionBanner> createState() => _PromotionBannerState();
}

class _PromotionBannerState extends ConsumerState<PromotionBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final carouselsAsync = ref.watch(mainCarouselsProvider);

    return carouselsAsync.when(
      data: (carousels) {
        if (carousels.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Carousel
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CarouselSlider(
                  options: CarouselOptions(
                    //height: 192,
                    aspectRatio: 2 / 1,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: carousels.length > 1,
                    reverse: false,
                    autoPlay: carousels.length > 1,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    enlargeFactor: 0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                  items: carousels.map((carousel) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () => _handleCarouselTap(context, carousel),
                          child: SizedBox.expand(
                            child: _buildCarouselContent(carousel),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Dot indicators
            if (carousels.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: carousels.asMap().entries.map((entry) {
                  return Container(
                    width: _currentIndex == entry.key ? 10 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentIndex == entry.key
                          ? AppColors.secondaryValueColor
                          : AppColors.thirdValueColor,
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 160,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCarouselContent(CarouselModel carousel) {
    final mediaType = MediaType.fromString(carousel.mediaType);

    switch (mediaType) {
      case MediaType.staticImage:
      case MediaType.loopingAnimation:
        return _buildImageContent(carousel.mediaUrl, carousel.fallbackUrl);

      case MediaType.video:
        // Show fallback image for video, tap to open fullscreen player
        return Stack(
          fit: StackFit.expand,
          children: [
            if (carousel.fallbackUrl != null)
              _buildImageContent(carousel.fallbackUrl!, null)
            else
              Container(
                color: Colors.grey[300],
                child: const Icon(Icons.play_circle_outline, size: 64),
              ),
            // Play button overlay
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ],
        );

      case MediaType.lottie:
        return _buildLottieContent(carousel.mediaUrl, carousel.fallbackUrl);
    }
  }

  Widget _buildImageContent(String imageUrl, String? fallbackUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryHighlightColor,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        // Try fallback URL if available
        if (fallbackUrl != null && fallbackUrl != imageUrl) {
          return _buildImageContent(fallbackUrl, null);
        }
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 64),
        );
      },
    );
  }

  Widget _buildLottieContent(String lottieUrl, String? fallbackUrl) {
    return Lottie.network(
      lottieUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Use fallback image if lottie fails
        if (fallbackUrl != null) {
          return _buildImageContent(fallbackUrl, null);
        }
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.animation, size: 64),
        );
      },
    );
  }

  Future<void> _handleCarouselTap(BuildContext context, CarouselModel carousel) async {
    // Track analytics event
    FirebaseAnalytics.instance.logEvent(
      name: 'banner_click',
      parameters: {
        'banner_id': carousel.id,
        'banner_name': carousel.title,
      },
    );

    final actionType = ActionType.fromString(carousel.actionType);
    final mediaType = MediaType.fromString(carousel.mediaType);

    // VIDEO type: Open fullscreen player
    if (mediaType == MediaType.video) {
      await VideoPlayerDialog.show(
        context,
        videoUrl: carousel.mediaUrl,
        title: carousel.title,
      );
      return;
    }

    // Handle other action types
    switch (actionType) {
      case ActionType.appPage:
        if (carousel.actionLink != null) {
          final deepLinkData = LinkParser.parseString(carousel.actionLink!);
          if (deepLinkData != null) {
            await DeepLinkRouterForWidgetRef(ref).navigate(deepLinkData);
          } else {
            _showInvalidLinkSnackBar();
          }
        }
        break;

      case ActionType.externalUrl:
      case ActionType.deeplink:
        if (carousel.actionLink != null) {
          final uri = Uri.tryParse(carousel.actionLink!);
          if (uri != null && await canLaunchUrl(uri)) {
            //_showExternalUrlConfirmDialog(carousel.actionLink!);
            final uri = Uri.parse(carousel.actionLink!);
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          } else {
            _showInvalidLinkSnackBar();
          }
        } else {
          _showInvalidLinkSnackBar();
        }
        break;

      case ActionType.none:
        // No action
        break;
    }
  }

  /*void _showExternalUrlConfirmDialog(String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleConfirmAlert(
        title: '前往外部連結',
        message: '是否確定離開ECOCO APP\n前往第三方網站',
        confirmText: '確定',
        cancelText: '取消',
        onConfirm: () async {
          final uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        },
        onCancel: () {},
      ),
    );
  }*/

  void _showInvalidLinkSnackBar() {
    SnackBarHelper.show(context, '連結失效 (null link)');
  }
}
