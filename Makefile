.PHONY: splashdev_watchicon lang clean test deps release before_build build_adhoc_ipa build_apk build_appstore_ipa build_appbundle build_production_appbundle build_mac cache_s3_lists cache_sites_list

test: before_build build_adhoc_ipa build_apk
release: before_build build_appstore_ipa build_appbundle
clean: clean_project deps before_build

deps:
	fvm flutter pub get
	fvm dart pub global activate flutterfire_cli

before_build:
	fvm dart run build_runner build

dev_watch:
	fvm dart run build_runner watch

lang:
	fvm flutter gen-l10n

icon:
	fvm dart run flutter_launcher_icons -f flutter_launcher_icons-mock.yaml
	fvm dart run flutter_launcher_icons -f flutter_launcher_icons-internal.yaml
	fvm dart run flutter_launcher_icons -f flutter_launcher_icons-production.yaml

splash:
	fvm dart run flutter_native_splash:create --flavor mock
	fvm dart run flutter_native_splash:create --flavor internal
	fvm dart run flutter_native_splash:create --flavor production

clean_project:
	@echo "╠ Cleaning the project..."
	@rm -rf pubspec.lock
	@fvm flutter clean
	rm -rf ios/Pods ios/podfile.lock
	cd ios; pod repo remove trunk; cd ..
	cd android; ./gradlew clean; cd ..

build_mock_ipa:
	-@fvm dart run tools/cache_s3_lists.dart develop
	@echo "╠ Building Mock flavor IPA (ios) ..."
	fvm flutter build ipa -t lib/main_mock.dart --flavor mock
	mv build/ios/ipa/*.ipa ~/Desktop/

build_adhoc_ipa:
	-@fvm dart run tools/cache_s3_lists.dart develop
	@echo "╠ Building Internal flavor IPA (ios) ..."
	fvm flutter build ipa -t lib/main_internal.dart --flavor internal --export-method=ad-hoc
	mv build/ios/ipa/*.ipa ~/Desktop/

build_appstore_ipa:
	-@fvm dart run tools/cache_s3_lists.dart develop
	@echo "╠ Building Internal flavor IPA (ios) ..."
	fvm flutter build ipa -t lib/main_internal.dart --flavor internal
	mv build/ios/ipa/*.ipa ~/Desktop/

build_production_appstore_ipa:
	-@fvm dart run tools/cache_s3_lists.dart production
	@echo "╠ Building Production flavor IPA (ios) ..."
	fvm flutter build ipa -t lib/main_production.dart --flavor production
	mv build/ios/ipa/*.ipa ~/Desktop/

build_mac:
	@echo "╠ Building Mac ..."
	fvm flutter build macos

build_mock_apk:
	@echo "╠ Building apk (Android) with Mock flavor..."
	-@fvm flutter build apk -t lib/main_mock.dart --flavor mock
	mv ./build/app/outputs/flutter-apk/*.apk ~/Desktop/

build_apk:
	-@fvm dart run tools/cache_s3_lists.dart develop
	@echo "╠ Building apk (Android) with Internal flavor..."
	-@fvm flutter build apk -t lib/main_internal.dart --flavor internal
	mv ./build/app/outputs/flutter-apk/*.apk ~/Desktop/

build_mock_appbundle:
	-@fvm dart run tools/cache_s3_lists.dart develop
	@echo "╠ Building appbundle (Android) with Mock flavor..."
	-@fvm flutter build appbundle -t lib/main_mock.dart --flavor mock

build_appbundle:
	-@fvm dart run tools/cache_s3_lists.dart develop
	@echo "╠ Building appbundle (Android) with Internal flavor..."
	-@fvm flutter build appbundle -t lib/main_internal.dart --flavor internal

build_production_appbundle:
	-@fvm dart run tools/cache_s3_lists.dart production
	@echo "╠ Building appbundle (Android) with Production flavor..."
	-@fvm flutter build appbundle -t lib/main_production.dart --flavor production

cache_s3_lists:
	@echo "╠ Caching S3 lists (sites, area/district, delete reasons)..."
	@echo "╠ Usage: make cache_s3_lists [ENV=develop|production]"
	fvm dart run tools/cache_s3_lists.dart $(if $(ENV),$(ENV),develop)

# Backward compatibility
cache_sites_list: cache_s3_lists
