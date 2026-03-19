import 'package:auto_route/auto_route.dart';
import '/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/pages/common/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import '/utils/router_analytics_extension.dart';

@RoutePage()
class RightsPage extends ConsumerStatefulWidget {
  const RightsPage({super.key});

  @override
  ConsumerState<RightsPage> createState() => _RightsPageState();
}

class _RightsPageState extends ConsumerState<RightsPage> {
  final bool _isLoading = false;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(appLocale?.rightProblem ?? ""),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(appLocale?.rightProblemPoints ?? ""),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _launchURL(
                              'https://www.ecocogroup.com/qa/#about_point');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.gavel_outlined),
                        title: Text(appLocale?.rightProblemTerm ?? ""),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: Text(appLocale?.rightProblemPrivacy ?? ""),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _launchURL(
                              'https://www.ecocogroup.com/privacy-policy-2/');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: Text(appLocale?.rightProblemDeleteAccoint ?? ""),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to delete account page for proper password verification and reason collection
                          context.router.pushThrottledWithTracking(const DeleteAccountRoute());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }
}
