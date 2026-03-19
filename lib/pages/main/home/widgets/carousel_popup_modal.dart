import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '/models/carousel_model.dart';
import '/constants/carousel_constants.dart';
import '/widgets/video_player_dialog.dart';
import '/utils/snackbar_helper.dart';
import '/services/deep_link/link_parser.dart';
import '/router/deep_link_router.dart';

/// Popup modal dialog that displays carousel content (HOME_POPUP_MODAL placement)
class CarouselPopupModal {
  static Future<void> show(
    BuildContext context,
    List<CarouselModel> carousels, {
    VoidCallback? onDismissForToday,
  }) {
    if (carousels.isEmpty) {
      return Future.value();
    }

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _CarouselPopupModalContent(
        carousels: carousels,
        onDismissForToday: onDismissForToday,
      ),
    );
  }
}

class _CarouselPopupModalContent extends ConsumerStatefulWidget {
  final List<CarouselModel> carousels;
  final VoidCallback? onDismissForToday;

  const _CarouselPopupModalContent({
    required this.carousels,
    this.onDismissForToday,
  });

  @override
  ConsumerState<_CarouselPopupModalContent> createState() =>
      _CarouselPopupModalContentState();
}

class _CarouselPopupModalContentState
    extends ConsumerState<_CarouselPopupModalContent> {
  int _currentIndex = 0;
  bool _dontShowToday = false;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.carousels.length > 1;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // 限制最大對話框寬度，避免在平板或是橫向螢幕時過度放大
    final dialogWidth = screenWidth > 400 ? 368.0 : screenWidth - 32; 
    double imageWidth = dialogWidth - 52; // Dialog 內部左右各 26px padding
    
    // 預設 4(高):3(寬) 比例，並限制最大高度不超過螢幕的高度的 0.6 倍，保留空間給下方按鈕
    double imageHeight = imageWidth * 4 / 3;
    final maxImageHeight = screenHeight * 0.6;
    if (imageHeight > maxImageHeight) {
      imageHeight = maxImageHeight;
      // 如果高度被限制碰頂，等比例縮小寬度，讓按鈕的寬度不會比縮小的圖片還寬
      imageWidth = imageHeight * 3 / 4;
    }

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // 圖片輪播區域
            Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: hasMultiple
                    ? _buildCarouselView(imageHeight)
                    : _buildSingleView(widget.carousels.first, imageHeight),
              ),
            ),

          const SizedBox(height: 12),

          // 圓點指示器（多張時顯示）
          if (hasMultiple) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.carousels.asMap().entries.map((entry) {
                return Container(
                  width: _currentIndex == entry.key ? 10 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentIndex == entry.key
                        ? AppColors.secondaryValueColor
                        : AppColors.dividerColor,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // 關閉按鈕
          SizedBox(
            width: imageWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryHighlightColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: _handleClose,
              child: const Text(
                '關閉',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 今日不再顯示勾選框
          GestureDetector(
            onTap: () => setState(() => _dontShowToday = !_dontShowToday),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _dontShowToday
                          ? AppColors.orangeBackground
                          : Colors.grey,
                      width: 2,
                    ),
                    color: _dontShowToday
                        ? AppColors.orangeBackground
                        : Colors.white,
                  ),
                  child: _dontShowToday
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                const Text(
                  '今日不再顯示',
                  style: TextStyle(
                    color: AppColors.secondaryValueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
      ),
    );
  }

  void _handleClose() {
    if (_dontShowToday && widget.onDismissForToday != null) {
      widget.onDismissForToday!();
    }
    Navigator.of(context).pop();
  }

  Widget _buildCarouselView(double height) {
    return CarouselSlider(
      carouselController: _carouselController,
      options: CarouselOptions(
        height: height,
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: widget.carousels.length > 1,
        autoPlay: widget.carousels.length > 1,
        autoPlayInterval: const Duration(seconds: 6),
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: widget.carousels.map((carousel) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => _handleCarouselTap(context, carousel),
              child: _buildCarouselContent(carousel),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSingleView(CarouselModel carousel, double height) {
    return GestureDetector(
      onTap: () => _handleCarouselTap(context, carousel),
      child: _buildCarouselContent(carousel),
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
                child: const Icon(Icons.play_circle_outline, size: 96),
              ),
            // Play button overlay
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 64,
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
        color: Colors.grey[200],
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
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.broken_image, size: 96),
          ),
        );
      },
    );
  }

  Widget _buildLottieContent(String lottieUrl, String? fallbackUrl) {
    return Lottie.network(
      lottieUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Use fallback image if lottie fails
        if (fallbackUrl != null) {
          return _buildImageContent(fallbackUrl, null);
        }
        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.animation, size: 96),
          ),
        );
      },
    );
  }

  Future<void> _handleCarouselTap(
      BuildContext context, CarouselModel carousel) async {
    // Track analytics event
    FirebaseAnalytics.instance.logEvent(
      name: 'carousel_click',
      parameters: {
        'carousel_id': carousel.id,
        'placement_key': carousel.placementKey,
        'promotion_code': carousel.promotionCode ?? '',
        'action_type': carousel.actionType,
        'media_type': carousel.mediaType,
      },
    );

    final actionType = ActionType.fromString(carousel.actionType);
    final mediaType = MediaType.fromString(carousel.mediaType);

    // VIDEO type: Close modal and open fullscreen player
    if (mediaType == MediaType.video) {
      Navigator.of(context).pop(); // Close modal first
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
            Navigator.of(context).pop(); // Close modal first
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
          Navigator.of(context).pop(); // Close popup modal
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
