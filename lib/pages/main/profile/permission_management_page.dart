import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/constants/colors.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class PermissionManagementPage extends StatefulWidget {
  const PermissionManagementPage({super.key});

  @override
  State<PermissionManagementPage> createState() =>
      _PermissionManagementPageState();
}

class _PermissionManagementPageState extends State<PermissionManagementPage> {
  String _locationPermissionStatus = '';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;
    setState(() {
      if (status.isGranted) {
        _locationPermissionStatus = '已開啟';
      } else {
        _locationPermissionStatus = '已關閉';
      }
    });
  }

  Future<void> _openLocationSettings() async {
    // Open system location settings
    // await Geolocator.openLocationSettings();
    await Geolocator.openAppSettings();

    // Refresh permission status when user returns
    Future.delayed(const Duration(milliseconds: 500), () {
      _checkLocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          appLocale?.priviledgeSetting ?? '權限管理', style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),),
        backgroundColor: AppColors.secondaryHighlightColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: const Text('地理位置權限'),
          subtitle: const Text('為您提供鄰近站點'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _locationPermissionStatus,
                style: TextStyle(
                  color: AppColors.indicatorColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.indicatorColor),
            ],
          ),
          onTap: _openLocationSettings,
        ),
      ),
    );
  }
}
