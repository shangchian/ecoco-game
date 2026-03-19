import 'package:ecoco_app/widgets/bottle_status_icon.dart';
import 'package:ecoco_app/widgets/milk_bottle_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // Added import
import '/constants/colors.dart';
import '/models/site_display_model.dart';
import '/models/site_model.dart';
import '/widgets/battery_status_icon.dart';
import '/widgets/alu_can_status_icon.dart';
import '/widgets/cup_status_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class SiteListCard extends StatelessWidget {
  final String title;
  final String address;
  final String serviceHours;
  final String? distance;
  final bool isFavorite;
  final SiteCardStatus status;
  final String? displayStatus; // Display status: NORMAL, SUSPENDED, COOPERATION_ENDED, HIDDEN
  final String? noteText; // 備註 field
  final SiteType? siteType; // Site type (GROUPED_BIN or SEPARATE_BIN)
  final List<RecyclableItemGroup> recyclableGroups;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final double? latitude;
  final double? longitude;
  final String? siteCode; // Add siteCode for analytics

  const SiteListCard({
    super.key,
    required this.title,
    required this.address,
    required this.serviceHours,
    this.distance,
    required this.recyclableGroups,
    this.isFavorite = false,
    this.status = SiteCardStatus.available,
    this.displayStatus,
    this.noteText,
    this.siteType,
    this.latitude,
    this.longitude,
    this.onTap,
    this.onFavoriteToggle,
    this.siteCode, // Initialize siteCode
  });

  Future<void> _launchGoogleMaps() async {
    if (latitude == null || longitude == null) return;

    FirebaseAnalytics.instance.logEvent(
      name: 'click_station',
      parameters: {
        'station_id': siteCode ?? 'unknown',
        'station_name': title,
      },
    );

    final url = 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback or error handling if needed
      debugPrint('Could not launch Google Maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildBody(context),
              ],
            ),
            if (_shouldShowOverlay()) _buildStatusOverlay(),
            Positioned(
              right: 20,
              top: -1,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Image.asset(
                  isFavorite
                      ? 'assets/images/ribbon_fav_yes.png'
                      : 'assets/images/ribbon_fav_no.png',
                  width: 25,
                  height: 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header section with blue background and title
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 5, 45, 5),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.stationHeaderBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Body section with station info and recyclable items
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location section with image and distance/address
          _buildLocationSection(),

          // Service hours
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.access_time_filled,
            text: '營業時間：$serviceHours',
          ),

          // Note/Remark text (optional)
          if (noteText != null && noteText!.isNotEmpty) ...[
            const SizedBox(height: 4),
            _buildInfoRow(
              icon: Icons.push_pin,
              text: noteText!,
              maxLines: 2,
            ),
          ],

          // Footer: Status badge + recyclable items
          const SizedBox(height: 12),
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Location section with image and distance/address text
  Widget _buildLocationSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side: Location logo image (conditionally tappable)
        _buildLocationLogo(),
        const SizedBox(width: 12),
        // Right side: Distance and address
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Distance text (only show if available)
              if (distance != null) ...[
                Text(
                  '距離 $distance',
                  style: const TextStyle(
                    color: AppColors.stationTextGray,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              // Address text
              Text(
                address,
                style: const TextStyle(
                  color: AppColors.stationTextDark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build location logo (tappable if coordinates available)
  Widget _buildLocationLogo() {
    final logo = Image.asset(
      'assets/images/loc_logo.png',
      width: 26,
      height: 26,
    );

    // Only make it tappable if we have coordinates
    if (latitude == null || longitude == null) {
      return logo;
    }

    return GestureDetector(
      onTap: _launchGoogleMaps,
      child: Container(
        padding: const EdgeInsets.all(2), // Increase tap target
        child: logo,
      ),
    );
  }

  /// Reusable info row with icon and text
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isSecondary = false,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: AppColors.stationTextGray,
          size: 18,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isSecondary
                  ? AppColors.stationTextGray
                  : AppColors.stationTextDark,
              fontSize: 14,
              fontWeight: isSecondary ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Footer section with status badge and recyclable items grid
  Widget _buildFooter(BuildContext context) {
    final footerFlex = _calculateFooterFlex();
    final needsSpacer = recyclableGroups.length < 3;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Row(
        children: [
          Flexible(
            flex: footerFlex,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: AppColors.greyBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Status badge
                    _buildStatusBadge(),

                    // Divider after status
                    Container(
                      width: 1,
                      height: double.infinity,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Recyclable items with dividers
                    Expanded(
                      child: _buildRecyclableItemsGrid(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (needsSpacer)
            Spacer(flex: 4 - footerFlex),
        ],
      ),
    );
  }

  /// Calculate flex ratio for footer based on number of recyclable groups
  /// Returns: 1 for single item (50%), 3 for two items (75%), 4 for 3+ items (100%)
  int _calculateFooterFlex() {
    if (recyclableGroups.isEmpty) return 1;

    switch (recyclableGroups.length) {
      case 1:
        return 2;  // 50% width (1:1 ratio with spacer)
      case 2:
        return 3;  // 75% width (3:1 ratio with spacer)
      default:
        return 4;  // 100% width (no spacer needed)
    }
  }

  /// Status badge with dynamic text and color based on station status
  Widget _buildStatusBadge() {
    final isAvailable = status == SiteCardStatus.available;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 6,
      ),
      child: Text(
        status.badgeText,
        style: TextStyle(
          color: isAvailable
            ? AppColors.stationGreenBadge
            : AppColors.stationGrayBadge,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  /// Grid of recyclable item groups with vertical dividers
  Widget _buildRecyclableItemsGrid() {
    if (recyclableGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];
    for (int i = 0; i < recyclableGroups.length; i++) {
      final group = recyclableGroups[i];

      // Add group column
      children.add(
        Expanded(
          child: _buildRecyclableItemGroupColumn(group),
        ),
      );

      // Add divider between groups (not after last group)
      if (i < recyclableGroups.length - 1) {
        children.add(
          Container(
            width: 1,
            height: double.infinity,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  /// Build column for a recyclable item group (single or grouped)
  Widget _buildRecyclableItemGroupColumn(RecyclableItemGroup group) {
    final isH30 = siteType == SiteType.separateBin;
    bool showNumber = _shouldShowNumber(group, isH30);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconsForGroup(group),
          if (showNumber) ...[
            const SizedBox(height: 4),
            _buildCountText(group),
          ],
        ],
      ),
    );
  }

  /// Determine if count number should be shown
  bool _shouldShowNumber(RecyclableItemGroup group, bool isH30) {
    if (isH30) return false;
    if (status == SiteCardStatus.maintenance) return false;
    return true;
  }

  /// Build icons for a group (single or multiple items)
  Widget _buildIconsForGroup(RecyclableItemGroup group) {
    if (group.types.length == 1) {
      return _buildSingleIcon(group.types.first, group);
    } else {
      return _buildMultipleIcons(group);
    }
  }

  /// Build single icon with individual status-based color
  Widget _buildSingleIcon(RecyclableItemType type, RecyclableItemGroup group) {
    final bool isIconActive = _determineIconActive(group, type);
    return _buildRecyclableItemIcon(type, isIconActive);
  }

  /// Build multiple icons with dividers (like current grouped bottles)
  Widget _buildMultipleIcons(RecyclableItemGroup group) {
    const double iconSize = 32;
    const double iconWidth = 22;
    final iconWidgets = <Widget>[];

    for (int i = 0; i < group.types.length; i++) {
      final itemType = group.types[i];
      final isIconActive = _determineIconActive(group, itemType);

      iconWidgets.add(
        SizedBox(
          width: iconWidth,
          height: iconSize,
          child: OverflowBox(
            maxWidth: iconSize,
            maxHeight: iconSize,
            child: _buildRecyclableItemIcon(itemType, isIconActive),
          ),
        ),
      );

      if (i < group.types.length - 1) {
        iconWidgets.add(
          Container(
            width: 1,
            height: iconSize,
            color: Colors.white,
          ),
        );
      }
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: iconWidgets,
      ),
    );
  }

  /// Determine if a specific icon should be active (green) or inactive (gray)
  bool _determineIconActive(RecyclableItemGroup group, RecyclableItemType type) {
    // For ALL sites, check maintenance/closed status first
    if (status == SiteCardStatus.maintenance) return false;
    if (status == SiteCardStatus.closed) return false;

    final isH30 = siteType == SiteType.separateBin;

    // For H30 (SEPARATE_BIN), check individual item status only
    // H30 doesn't have bin capacity, so we only check UP/DOWN status
    if (isH30) {
      final itemStatus = group.getItemStatus(type);
      return itemStatus == 'UP';
    }

    // For GROUPED_BIN, check both status AND capacity
    final itemStatus = group.getItemStatus(type);
    final isItemUp = itemStatus == 'UP';
    final hasCapacity = group.count != null && group.count! > 0;

    return isItemUp && hasCapacity;
  }

  /// Check if all items in the group have "DOWN" status
  bool _areAllItemsDown(RecyclableItemGroup group) {
    // If site is closed or in maintenance, don't apply the Down rule
    // (let the existing closed/maintenance logic handle it)
    if (status == SiteCardStatus.closed || status == SiteCardStatus.maintenance) {
      return false;
    }

    // Check if all items in the group have DOWN status
    for (final type in group.types) {
      final itemStatus = group.getItemStatus(type);
      if (itemStatus == 'UP') {
        return false; // At least one item is UP, so not all are down
      }
    }

    return true; // All items are DOWN
  }

  /// Build count text with color based on availability
  Widget _buildCountText(RecyclableItemGroup group) {
    Color countColor;
    String displayCount;

    // Check if all items in this group are DOWN
    final allItemsDown = _areAllItemsDown(group);

    if (allItemsDown) {
      // Rule: If all items are DOWN, show "0" in gray
      countColor = AppColors.stationIconGray;
      displayCount = '0';
    } else if (status == SiteCardStatus.closed || status == SiteCardStatus.maintenance) {
      // Site is closed, show gray with actual count
      countColor = AppColors.stationIconGray;
      displayCount = group.count?.toString() ?? '0';
    } else {
      // Normal logic: green if has capacity, gray if no capacity
      countColor = (group.count != null && group.count! > 0)
          ? AppColors.stationGreenBadge
          : AppColors.stationGrayBadge;
      displayCount = group.count?.toString() ?? '0';
    }

    return Text(
      displayCount,
      style: TextStyle(
        color: countColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Get the appropriate status icon widget for each recyclable item type
  Widget _buildRecyclableItemIcon(RecyclableItemType type, bool isEnabled) {
    const double iconSize = 32;

    switch (type) {
      case RecyclableItemType.petBottle:
        return BottleStatusIcon(isEnabled: isEnabled, size: iconSize);
      case RecyclableItemType.hdpeBottle:
        return MilkBottleStatusIcon(isEnabled: isEnabled, size: iconSize);
      case RecyclableItemType.battery:
        return BatteryStatusIcon(isEnabled: isEnabled, size: iconSize);
      case RecyclableItemType.ppCup:
        return CupStatusIcon(isEnabled: isEnabled, size: iconSize);
      case RecyclableItemType.aluminumCan:
        return AluCanStatusIcon(isEnabled: isEnabled, size: iconSize);
    }
  }

  /// Determine if status overlay should be shown
  bool _shouldShowOverlay() {
    return displayStatus == 'SUSPENDED' ||
           displayStatus == 'COOPERATION_ENDED';
  }

  /// Build semi-transparent overlay with stamp image
  Widget _buildStatusOverlay() {
    final stampImage = displayStatus == 'SUSPENDED'
        ? 'assets/images/suspended_stamp.png'
        : 'assets/images/cooperation_ended_stamp.png';

    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: Container(
          color: Colors.white.withValues(alpha: 0.85),
          child: Center(
            child: Image.asset(
              stampImage,
              width: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
