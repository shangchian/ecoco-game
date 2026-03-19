# ECOCO 循環經濟 App

## Getting Started

### Requirement
* Flutter Developtment Envirement
  * 當前使用 Flutter 3.24.4 (channel stable) 進行開發，切換 Flutter 版本的方式參考以下兩點：
  * [選配] 切換版本方式：
    * Clone Flutter Source Code，透過 Tag 切換版本
    * 使用 FVM 來管理 Flutter 版本，可方便切換版本，版本可參考`.fvmrc`，更新版本也務必更新此檔案
  * [選配] 使用 VSCode 進行開發，並安裝相關的插件
* 開發工具
  * Git with LFS support
  * [選配] Makefile
* iOS 開發環境
  * Apple Developer 發布權限
  * Xcode
  * Cocopods
* Android 開發環境
  * Play Store Console 發布權限
  * Android Keystore
  * Android Studio
* Firebase Developer
  * [ECOCOApp Universal 權限](https://console.firebase.google.com/u/1/project/ecoco-app-v2/overview)
  * Firebase CLI

### Installation
1. Clone the repository and initialize submodules
```bash
git clone https://gitlab.com/yikeke/ecoco-app.git
```
2. Install dependencies, generate necessary code and Firebase: `make deps`
<details>
  <summary>Setup Manually</summary>

```bash
flutter pub get
dart pub global activate flutterfire_cli
```
</details>

3. Configure Firebase and generate firebase_options.dart: `flutterfire configure`
4. Set up the Android signing environment
    * Download the following files from [Google Drive of Android Keystore]() and place them in `./android/`
      * keystore.properties
      * keystore.jks
5. Install the necessary packages
    * `dart pub global activate flutter_asset_generator`

### Development and Debug
* VSCode / Cursor
  * Use the provided debug configuration (launch.json) in the development environment.
<details>
  <summary>launch.json example</summary>

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Internal",
            "request": "launch",
            "type": "dart",
            "args": ["--flavor", "internal"]
        },
        {
            "name": "Production",
            "request": "launch",
            "type": "dart",
            "args": ["--flavor", "production"]
        },
        {
            "name": "Internal Profile",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile",
            "args": ["--flavor", "internal"]
        },
        {
            "name": "Production Release",
            "request": "launch",
            "type": "dart",
            "args": ["--flavor", "production"],
            "flutterMode": "release"
        }
    ]
}
```
</details>

* CLI
  * Choose the appropriate flavor: preparing or production.
  * *preparing* use Kdan Cloud Preparing Server
  * *production* use Kdan Cloud Production Server
```bash
flutter run
```

### 目錄結構
* screens: This folder contains the widget code that’s rendered on the screen.
* states: This folder contains all the states that widget apdat to render something different.
* notifiers: This folder contains the business logic to manage the widget state.
* services: This folder contains the business logic to manage the application state.
* models: This folder contains the data model to share data coming from the repository to notifiers or services.
* repositories: This folder contains the handling for data coming in and out from your database or server.
* data_providers: This folder contains all your data sources, such as fake data, server calls, or database calls.
* l10n: This folder contains the localization files.

### 環境 (flavor)
* internal 環境：為測試用
* production 環境：為上架用
* 差異
  * Bundle Name / Bundle ID 會不同，可以在 pubspec.yaml 內 `flavorizr` 設定
  * icon 不同，參考 [Icon 替換](### Icon 替換) 修改
  * splash 不同，參考 [Splash Screen替換](### Splash Screen 替換) 修改

### 開發過程工具
1. `make dev_watch` 啟動 Hot Reload 自動產生需求的程式碼，包含 `auto_route` 、 `l10n` 、 `JsonSerializable` 、 `Riverpod` 的程式碼
2. 清理專案，使用 `make clean_project`
3. 編譯 Android 專案，debug用apk檔使用 `make build_apk`，送審測試用appbundle檔使用 `make build_appbundle`，送審上架版本使用`make build_production_appbundle`
4. 編譯 iOS 專案，debug用ipa檔使用 `make build_adhoc_ipa` 可編譯出直接安裝至手機的版本，送審測試用appbundle檔使用 `make build_appstore_ipa` 可編譯出testflight使用的版本，送審上架版本使用`make build_production_appstore_ipa`
5. 更新app內站點(station list)快取 `make cache_stations_list`，送審前都需要做

### Icon 替換

1. 將 icon.png 放置在 assets/icon/icon.png
2. 檢視並調整 flutter_launcher_icons-internal.yaml 及 flutter_launcher_icons-production.yaml 設定
3. 執行以下指令 `make icon`
4. 編譯程序修正，可以在 Makefile 內做

### Splash Screen 替換
1. 將 Splash Screen 圖片放置在 assets/splash.png
2. 檢視並調整 flutter_native_splash-internal.yaml 及 flutter_native_splash-production.yaml 設定
3. 執行 `make splash` 產生 Splash Screen
4. 編譯程序修正，可以在 Makefile 內做

### App內向量圖處理方式
1. 在Figma內選取圖片的Group，選擇 Export as svg，建立檔案後(放置 assets/svgs內)，貼上儲存
2. 打開 [FlutterIcon](https://www.fluttericon.com/)，把 assets/svgs/config.json 以及新增的svg拖進去，把拖進去的檔案全部選取來，選擇Export後下載zip檔案
3. 把 zip 檔案解壓縮後
  1. 把zip檔案內的 fonts/ECOCOIcons.ttf 取代專案內 asets/fonts/ECOCOIcons.ttf
  2. 打開zip檔案內的 e_c_o_c_o_icons_icons.darts的內容取代專案內 lib/ecoco_icons.dart
  3. 把zip檔案內 config.json 覆蓋 assets/svgs/config.json
4. [選] 如果 Icon 長得跟 Figma 不一樣，參考[這個頁面使用Inkscape](https://github.com/fontello/fontello/wiki/How-to-use-custom-images#importing-svg-images)處理
  1. 安裝並打開 Inkscape
  2. 隨便建立一個 canvas 把 svg 檔案複製進去
  3. 選取該svg圖示
  4. Document Properties -> Resize page to drawing or selection (Inkscape v1.3: Edit -> Resize Page to Selection)
  5. Object -> Ungroup
  6. Path -> Stroke to Path
  7. Path -> Union
  8. Path -> Combine
  9. File -> Clean up document (or Vacuum Defs)
  10. Set the document to use PX units
  11. Save as -> Plain SVG 取代原本的svg

### JAVA 1.7 相關問題
* Android Studio 2024.2.1 以上，如果遇到 `Java installation no longer found` 的問題需進行以下設定
  * 需要在 Android Studio 內降級 Java 版本至 17，請參閱 [Stackoverflow說明](https://stackoverflow.com/questions/79049863/android-studio-ladybug-your-build-is-currently-configured-to-use-incompatible-j)
  * 根據上方文件，在 Mac 底下會下載 Jetbrains Java Runtime 17.x.x
  * 在 Flutter 進行編譯時需要指定正確的 JAVA_HOME，例如 `export JAVA_HOME=~/Library/Java/JavaVirtualMachines/jbrsdk_jcef-17.0.12/Contents/Home`，可寫至 `~/.zshrc`，設定完之後重啟 Terminal
  * 嘗試編譯

### 版本號定義
* v3.2.0+yyyyMMdd
  * 第一碼：架構更新。（需要共同決議才能進版）
  * 第二碼：功能更新。（需要共同決議才能進版）
  * 第三碼：修復問題。
  * 版號：西元日期。