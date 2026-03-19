import 'package:auto_route/auto_route.dart';
import '/providers/version_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/l10n/app_localizations.dart';
import '/constants/colors.dart';

@RoutePage()
class VersionPage extends ConsumerStatefulWidget {
  const VersionPage({super.key});

  @override
  ConsumerState<VersionPage> createState() => _VersionPageState();
}

class _VersionPageState extends ConsumerState<VersionPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(versionProvider.notifier).loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(versionProvider);
    final appLocale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.secondaryHighlightColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        title: Text(appLocale?.systemVersion ?? "", style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0), child: 
            ListTile(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(appLocale?.appVersion ?? ""),
              ),
              trailing: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(info.version,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                ),
              ),
            )),
            const Divider(height: 1),
            Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0), child: 
            ListTile(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(appLocale?.phoneModel ?? ""),
              ),
              trailing: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(info.model,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                ),
              ),
            )),
            const Divider(height: 1),
            Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0), child: ListTile(
              title: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(appLocale?.phoneVersion ?? ""),
              ),
              trailing: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(info.systemVersion,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      )),
                ),
              ),
            )),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
