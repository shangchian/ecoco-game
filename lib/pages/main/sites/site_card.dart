import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/models/site_model.dart';
import '../../../widgets/bottle_status_icon.dart';
import '../../../widgets/battery_status_icon.dart';
import '../../../widgets/cup_status_icon.dart';
import '../../../widgets/alu_can_status_icon.dart';

enum SiteStatus {
  open, // 正常營業 - 綠色
  error, // 營業點異常 - 紅色
  closed, // 暫停營業 - 灰色
}

class SiteCard extends StatelessWidget {
  final String title;
  final String address;
  final String serviceHours;
  final SiteStatus status;
  final double? distance;
  final List<RecyclableItemType> recyclableItems; // 可回收物品列表
  final SiteType siteType;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final double? latitude;
  final double? longitude;

  const SiteCard({
    super.key,
    required this.title,
    required this.address,
    required this.serviceHours,
    required this.status,
    required this.recyclableItems,
    required this.siteType,
    this.latitude,
    this.longitude,
    this.distance,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  Color _getStatusColor() {
    switch (status) {
      case SiteStatus.open:
        return Colors.green;
      case SiteStatus.error:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _launchGoogleMaps() async {
    if (latitude == null || longitude == null) return;

    // 使用經緯度構建導航 URL
    final url = 'google.navigation:q=$latitude,$longitude';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // 備用網頁版 Google Maps
      final webUrl =
          'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
      final webUri = Uri.parse(webUrl);
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Widget _buildStatusIcon(RecyclableItemType item) {
    final bool isEnabled = status == SiteStatus.open;
    const double iconSize = 48.0;

    switch (item) {
      case RecyclableItemType.petBottle:
      case RecyclableItemType.hdpeBottle:
        return BottleStatusIcon(isEnabled: isEnabled, size: iconSize);
      case RecyclableItemType.battery:
        return BatteryStatusIcon(isEnabled: isEnabled, size: iconSize);
      case RecyclableItemType.ppCup:
        return CupStatusIcon(isEnabled: isEnabled, size: iconSize);
      case RecyclableItemType.aluminumCan:
        return AluCanStatusIcon(isEnabled: isEnabled, size: iconSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getStatusColor(),
          width: 0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 18,
                color: _getStatusColor(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (onFavoriteToggle != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.amber : Colors.grey,
                              ),
                              onPressed: onFavoriteToggle,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '營業時間 $serviceHours',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (recyclableItems.isNotEmpty ||
                          (latitude != null && longitude != null)) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 左側可回收物品列表區域
                            Expanded(
                              child: recyclableItems.isNotEmpty
                                  ? SizedBox(
                                      height: 48,
                                      child: Row(
                                        children: recyclableItems.map((item) {
                                          return Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 2),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: _buildStatusIcon(item),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                            // 右側導航按鈕
                            if (latitude != null && longitude != null && distance != null)
                              SizedBox(
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: TextButton.icon(
                                        onPressed: _launchGoogleMaps,
                                        icon: Icon(
                                          Icons.directions,
                                          color: _getStatusColor(),
                                          size: 20,
                                        ),
                                        label: Text(
                                          '導航',
                                          style: TextStyle(
                                            color: _getStatusColor(),
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        distance! > 999
                                            ? '無限大 km'
                                            : '${distance!.toStringAsFixed(2)} km',
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
