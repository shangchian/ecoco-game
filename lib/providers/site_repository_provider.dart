import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/providers/app_database_provider.dart';
import '/providers/sites_service_provider.dart';
import '/repositories/site_repository.dart';

part 'site_repository_provider.g.dart';

@Riverpod(keepAlive: true)
SiteRepository siteRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final sitesService = ref.watch(sitesServiceProvider);
  return SiteRepository(db: db, sitesService: sitesService);
}
