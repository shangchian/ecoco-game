import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:ecoco_app/models/activity_model.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onTap,
  });

  bool _isAssetPath(String path) {
    return path.startsWith('assets/');
  }

  Widget _buildIconImage() {
    final iconUrl = activity.iconUrl;

    if (iconUrl.isEmpty) {
      return Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 30,
      );
    }

    if (_isAssetPath(iconUrl)) {
      return Image.asset(
        iconUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image_not_supported,
          color: Colors.grey[400],
          size: 30,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: iconUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryHighlightColor,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Rounded square icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            clipBehavior: Clip.hardEdge,
            child: _buildIconImage(),
          ),
          const SizedBox(width: 12),
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryValueColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // "查看" button
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.indicatorColor,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              '查看',
              style: TextStyle(
                color: AppColors.indicatorColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
