import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:ecoco_app/providers/site_provider.dart';
import '/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sites_list_view.dart';
import '/constants/colors.dart';
import '../../../../pages/common/alerts/image_display_dialog.dart';

@RoutePage()
class SitePage extends ConsumerStatefulWidget {
  final Function(bool) onLoadingChanged;
  const SitePage({super.key, required this.onLoadingChanged});

  @override
  ConsumerState<SitePage> createState() => _SitePageState();
}

class _SitePageState extends ConsumerState<SitePage>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        ref.read(sitesProvider.notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User returned from settings - refresh permission status
      ref.read(userLocationProvider.notifier).refreshPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.greyBackground,
        appBar: AppBar(
          backgroundColor: AppColors.secondaryHighlightColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 64,
          centerTitle: false,
          title: Image.asset(
            'assets/images/ecoco_logo_pure.png',
            height: 25,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'ECOCO',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
                size: 28,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              onPressed: () {
                ImageDisplayDialog.show(context,
                    imagePath: 'assets/images/site_manual.webp');
              },
            ),
          ],
        ),
        body: SitesListView(onLoadingChanged: widget.onLoadingChanged),
      ),
    );
  }
}
