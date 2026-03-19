import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('zh')];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'ECOCO 循環經濟'**
  String get appTitle;

  /// No description provided for @account.
  ///
  /// In zh, this message translates to:
  /// **'帳號'**
  String get account;

  /// No description provided for @accountHint.
  ///
  /// In zh, this message translates to:
  /// **'輸入您的手機門號'**
  String get accountHint;

  /// No description provided for @password.
  ///
  /// In zh, this message translates to:
  /// **'密碼'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入8~20位英文或數字'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In zh, this message translates to:
  /// **'忘記密碼'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In zh, this message translates to:
  /// **'記住我'**
  String get rememberMe;

  /// No description provided for @useBiometric.
  ///
  /// In zh, this message translates to:
  /// **'啟用生物識別登入'**
  String get useBiometric;

  /// No description provided for @login.
  ///
  /// In zh, this message translates to:
  /// **'登入'**
  String get login;

  /// No description provided for @reverify.
  ///
  /// In zh, this message translates to:
  /// **'再次驗證'**
  String get reverify;

  /// No description provided for @register.
  ///
  /// In zh, this message translates to:
  /// **'註冊新會員'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'登出'**
  String get logout;

  /// No description provided for @registerTitle.
  ///
  /// In zh, this message translates to:
  /// **'註冊會員'**
  String get registerTitle;

  /// No description provided for @phoneVerification.
  ///
  /// In zh, this message translates to:
  /// **'手機驗證'**
  String get phoneVerification;

  /// No description provided for @phoneVerificationTitle.
  ///
  /// In zh, this message translates to:
  /// **'請設定帳號並完成簡訊驗證'**
  String get phoneVerificationTitle;

  /// No description provided for @phoneVerificationHint.
  ///
  /// In zh, this message translates to:
  /// **'輸入您的手機門號'**
  String get phoneVerificationHint;

  /// No description provided for @verifyPhone.
  ///
  /// In zh, this message translates to:
  /// **'手機門號驗證'**
  String get verifyPhone;

  /// No description provided for @setAccount.
  ///
  /// In zh, this message translates to:
  /// **'設定帳號'**
  String get setAccount;

  /// No description provided for @setPassword.
  ///
  /// In zh, this message translates to:
  /// **'設定密碼'**
  String get setPassword;

  /// No description provided for @setPasswordTitle.
  ///
  /// In zh, this message translates to:
  /// **'請設定您的密碼'**
  String get setPasswordTitle;

  /// No description provided for @confirmPassword.
  ///
  /// In zh, this message translates to:
  /// **'再次輸入密碼'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In zh, this message translates to:
  /// **'輸入密碼'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordError.
  ///
  /// In zh, this message translates to:
  /// **'密碼不一致'**
  String get confirmPasswordError;

  /// No description provided for @personalInformation.
  ///
  /// In zh, this message translates to:
  /// **'個人資料'**
  String get personalInformation;

  /// No description provided for @personalInformationTitle.
  ///
  /// In zh, this message translates to:
  /// **'請填寫您的個人資料'**
  String get personalInformationTitle;

  /// No description provided for @next.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get next;

  /// No description provided for @complete.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get complete;

  /// No description provided for @termsAndConditions.
  ///
  /// In zh, this message translates to:
  /// **'服務條款與隱私權政策'**
  String get termsAndConditions;

  /// No description provided for @agree.
  ///
  /// In zh, this message translates to:
  /// **'我同意'**
  String get agree;

  /// No description provided for @agreeHint.
  ///
  /// In zh, this message translates to:
  /// **'我已閱讀並同意'**
  String get agreeHint;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隱私權政策'**
  String get privacyPolicy;

  /// No description provided for @readAndAgree.
  ///
  /// In zh, this message translates to:
  /// **'請先閱讀並同意服務條款與隱私權政策'**
  String get readAndAgree;

  /// No description provided for @name.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get name;

  /// No description provided for @nameHint.
  ///
  /// In zh, this message translates to:
  /// **'輸入您的姓名'**
  String get nameHint;

  /// No description provided for @nickname.
  ///
  /// In zh, this message translates to:
  /// **'會員名稱'**
  String get nickname;

  /// No description provided for @nicknameHint.
  ///
  /// In zh, this message translates to:
  /// **'您希望我們怎麼稱呼您？'**
  String get nicknameHint;

  /// No description provided for @nicknameEditHint.
  ///
  /// In zh, this message translates to:
  /// **'僅接受中英文和數字或空格的混合輸入'**
  String get nicknameEditHint;

  /// No description provided for @nicknameInfo.
  ///
  /// In zh, this message translates to:
  /// **'僅接受中英文和數字或空格的混合輸入'**
  String get nicknameInfo;

  /// No description provided for @nicknameError.
  ///
  /// In zh, this message translates to:
  /// **'格式不正確'**
  String get nicknameError;

  /// No description provided for @nicknameErrorEmpty.
  ///
  /// In zh, this message translates to:
  /// **'請輸入會員名稱'**
  String get nicknameErrorEmpty;

  /// No description provided for @nicknameFormatError.
  ///
  /// In zh, this message translates to:
  /// **'名稱格式不符規定'**
  String get nicknameFormatError;

  /// No description provided for @nicknameInfoCharLimit.
  ///
  /// In zh, this message translates to:
  /// **'限10字內，可輸入中英文、數字或空格'**
  String get nicknameInfoCharLimit;

  /// No description provided for @nicknameInfoPublicWarning.
  ///
  /// In zh, this message translates to:
  /// **'此名稱將公開顯示，請避免使用不當字詞'**
  String get nicknameInfoPublicWarning;

  /// No description provided for @email.
  ///
  /// In zh, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In zh, this message translates to:
  /// **'輸入您的聯絡信箱'**
  String get emailHint;

  /// No description provided for @emailError.
  ///
  /// In zh, this message translates to:
  /// **'電子郵件格式不正確'**
  String get emailError;

  /// No description provided for @emailErrorEmpty.
  ///
  /// In zh, this message translates to:
  /// **'請輸入電子郵件'**
  String get emailErrorEmpty;

  /// No description provided for @emailErrorHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入有效的電子郵件格式'**
  String get emailErrorHint;

  /// No description provided for @emailErrorTitle.
  ///
  /// In zh, this message translates to:
  /// **'電子郵件格式錯誤'**
  String get emailErrorTitle;

  /// No description provided for @emailErrorContent.
  ///
  /// In zh, this message translates to:
  /// **'請輸入正確的電子郵件格式'**
  String get emailErrorContent;

  /// No description provided for @gender.
  ///
  /// In zh, this message translates to:
  /// **'性別'**
  String get gender;

  /// No description provided for @genderNotSelected.
  ///
  /// In zh, this message translates to:
  /// **'請選擇'**
  String get genderNotSelected;

  /// No description provided for @genderHint.
  ///
  /// In zh, this message translates to:
  /// **'請選擇性別'**
  String get genderHint;

  /// No description provided for @male.
  ///
  /// In zh, this message translates to:
  /// **'男'**
  String get male;

  /// No description provided for @female.
  ///
  /// In zh, this message translates to:
  /// **'女'**
  String get female;

  /// No description provided for @unknown.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get unknown;

  /// No description provided for @birthday.
  ///
  /// In zh, this message translates to:
  /// **'生日'**
  String get birthday;

  /// No description provided for @birthdayHint.
  ///
  /// In zh, this message translates to:
  /// **'請選擇'**
  String get birthdayHint;

  /// No description provided for @genderBirthdayEditableHint.
  ///
  /// In zh, this message translates to:
  /// **'性別、生日可編輯一次，儲存後無法變更'**
  String get genderBirthdayEditableHint;

  /// No description provided for @location.
  ///
  /// In zh, this message translates to:
  /// **'縣市區域'**
  String get location;

  /// No description provided for @locationHint.
  ///
  /// In zh, this message translates to:
  /// **'選擇縣市與區域'**
  String get locationHint;

  /// No description provided for @subscribeNews.
  ///
  /// In zh, this message translates to:
  /// **'我想收到 ECOCO電子報 獲得最新活動優惠資訊'**
  String get subscribeNews;

  /// No description provided for @subscribeNewsHint.
  ///
  /// In zh, this message translates to:
  /// **'接收最新優惠和活動資訊'**
  String get subscribeNewsHint;

  /// No description provided for @finishedRegister.
  ///
  /// In zh, this message translates to:
  /// **'完成註冊'**
  String get finishedRegister;

  /// No description provided for @exit.
  ///
  /// In zh, this message translates to:
  /// **'離開'**
  String get exit;

  /// No description provided for @continueFill.
  ///
  /// In zh, this message translates to:
  /// **'繼續填寫'**
  String get continueFill;

  /// No description provided for @notFinishRegister.
  ///
  /// In zh, this message translates to:
  /// **'會員註冊尚未完成'**
  String get notFinishRegister;

  /// No description provided for @otp.
  ///
  /// In zh, this message translates to:
  /// **'驗證碼'**
  String get otp;

  /// No description provided for @otpHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入6位數驗證碼'**
  String get otpHint;

  /// No description provided for @otpHint2.
  ///
  /// In zh, this message translates to:
  /// **'請輸入簡訊驗證碼'**
  String get otpHint2;

  /// No description provided for @otpErrorEmpty.
  ///
  /// In zh, this message translates to:
  /// **'請輸入驗證碼'**
  String get otpErrorEmpty;

  /// No description provided for @otpErrorLength.
  ///
  /// In zh, this message translates to:
  /// **'驗證碼長度錯誤'**
  String get otpErrorLength;

  /// No description provided for @otpErrorInput.
  ///
  /// In zh, this message translates to:
  /// **'驗證碼輸入錯誤'**
  String get otpErrorInput;

  /// No description provided for @otpErrorInput2.
  ///
  /// In zh, this message translates to:
  /// **'手機號碼輸入錯誤，請重新認證'**
  String get otpErrorInput2;

  /// No description provided for @otpFormatInvalid.
  ///
  /// In zh, this message translates to:
  /// **'驗證碼為6碼，請重新輸入'**
  String get otpFormatInvalid;

  /// No description provided for @otpIncorrect.
  ///
  /// In zh, this message translates to:
  /// **'驗證碼輸入錯誤，請重新輸入'**
  String get otpIncorrect;

  /// No description provided for @otpNumericOnly.
  ///
  /// In zh, this message translates to:
  /// **'請輸入數字驗證碼'**
  String get otpNumericOnly;

  /// No description provided for @otpTitle.
  ///
  /// In zh, this message translates to:
  /// **'OTP簡訊驗證'**
  String get otpTitle;

  /// No description provided for @otpSent.
  ///
  /// In zh, this message translates to:
  /// **'驗證碼已發送'**
  String get otpSent;

  /// No description provided for @phone.
  ///
  /// In zh, this message translates to:
  /// **'手機號碼'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入手機門號'**
  String get phoneHint;

  /// No description provided for @passwordEdit.
  ///
  /// In zh, this message translates to:
  /// **'修改密碼'**
  String get passwordEdit;

  /// No description provided for @passwordEditCurrentHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入目前密碼'**
  String get passwordEditCurrentHint;

  /// No description provided for @passwordEditCurrentLabel.
  ///
  /// In zh, this message translates to:
  /// **'目前密碼'**
  String get passwordEditCurrentLabel;

  /// No description provided for @passwordEditNewHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入新密碼'**
  String get passwordEditNewHint;

  /// No description provided for @passwordEditNewLabel.
  ///
  /// In zh, this message translates to:
  /// **'設定新密碼'**
  String get passwordEditNewLabel;

  /// No description provided for @passwordEditNewConfirmHint.
  ///
  /// In zh, this message translates to:
  /// **'請再次輸入新密碼'**
  String get passwordEditNewConfirmHint;

  /// No description provided for @passwordEditNewConfirmLabel.
  ///
  /// In zh, this message translates to:
  /// **'再次輸入新密碼'**
  String get passwordEditNewConfirmLabel;

  /// No description provided for @passwordRuleMsg.
  ///
  /// In zh, this message translates to:
  /// **'需包含英文字母及數字，長度8~20個英數字'**
  String get passwordRuleMsg;

  /// No description provided for @passwordLabel.
  ///
  /// In zh, this message translates to:
  /// **'密碼'**
  String get passwordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In zh, this message translates to:
  /// **'設定新密碼'**
  String get newPasswordLabel;

  /// No description provided for @newPasswordVerifyLabel.
  ///
  /// In zh, this message translates to:
  /// **'再次輸入密碼'**
  String get newPasswordVerifyLabel;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In zh, this message translates to:
  /// **'弱'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In zh, this message translates to:
  /// **'中'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In zh, this message translates to:
  /// **'強'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordStrengthVeryStrong.
  ///
  /// In zh, this message translates to:
  /// **'非常強'**
  String get passwordStrengthVeryStrong;

  /// No description provided for @passwordRequirementsMet.
  ///
  /// In zh, this message translates to:
  /// **'密碼符合所有要求'**
  String get passwordRequirementsMet;

  /// No description provided for @passwordRequirementsPrefix.
  ///
  /// In zh, this message translates to:
  /// **'尚需: '**
  String get passwordRequirementsPrefix;

  /// No description provided for @passwordRequirementMinLength.
  ///
  /// In zh, this message translates to:
  /// **'至少8個字元'**
  String get passwordRequirementMinLength;

  /// No description provided for @passwordRequirementDigit.
  ///
  /// In zh, this message translates to:
  /// **'需包含數字'**
  String get passwordRequirementDigit;

  /// No description provided for @passwordRequirementLowercase.
  ///
  /// In zh, this message translates to:
  /// **'需包含小寫字母'**
  String get passwordRequirementLowercase;

  /// No description provided for @passwordRequirementUppercase.
  ///
  /// In zh, this message translates to:
  /// **'需包含大寫字母'**
  String get passwordRequirementUppercase;

  /// No description provided for @passwordValidatorEmpty.
  ///
  /// In zh, this message translates to:
  /// **'請輸入密碼'**
  String get passwordValidatorEmpty;

  /// No description provided for @passwordValidatorLength.
  ///
  /// In zh, this message translates to:
  /// **'密碼長度至少需要8個字元'**
  String get passwordValidatorLength;

  /// No description provided for @passwordValidatorDigit.
  ///
  /// In zh, this message translates to:
  /// **'密碼需要包含數字'**
  String get passwordValidatorDigit;

  /// No description provided for @passwordValidatorLowercase.
  ///
  /// In zh, this message translates to:
  /// **'密碼需要包含小寫字母'**
  String get passwordValidatorLowercase;

  /// No description provided for @passwordValidatorUppercase.
  ///
  /// In zh, this message translates to:
  /// **'密碼需要包含大寫字母'**
  String get passwordValidatorUppercase;

  /// No description provided for @passwordNotMatch.
  ///
  /// In zh, this message translates to:
  /// **'兩次密碼不一致，請重新輸入'**
  String get passwordNotMatch;

  /// No description provided for @passwordFormatInvalid.
  ///
  /// In zh, this message translates to:
  /// **'密碼格式不符規定'**
  String get passwordFormatInvalid;

  /// No description provided for @phoneFormatInvalid.
  ///
  /// In zh, this message translates to:
  /// **'請輸入有效的號碼，例：0912345678'**
  String get phoneFormatInvalid;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In zh, this message translates to:
  /// **'該門號已被註冊'**
  String get phoneAlreadyRegistered;

  /// No description provided for @verifyPhoneAgain.
  ///
  /// In zh, this message translates to:
  /// **'重發驗證碼'**
  String get verifyPhoneAgain;

  /// No description provided for @district.
  ///
  /// In zh, this message translates to:
  /// **'鄉鎮市區'**
  String get district;

  /// No description provided for @districtHint.
  ///
  /// In zh, this message translates to:
  /// **'選擇行政區'**
  String get districtHint;

  /// No description provided for @forgetPasswordTitle.
  ///
  /// In zh, this message translates to:
  /// **'忘記密碼'**
  String get forgetPasswordTitle;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @inputPhoneStepTitle.
  ///
  /// In zh, this message translates to:
  /// **'輸入帳號'**
  String get inputPhoneStepTitle;

  /// No description provided for @inputPhoneStepHint.
  ///
  /// In zh, this message translates to:
  /// **'請確認您的手機門號'**
  String get inputPhoneStepHint;

  /// No description provided for @inputPhoneFieldHint.
  ///
  /// In zh, this message translates to:
  /// **'輸入您的手機門號'**
  String get inputPhoneFieldHint;

  /// No description provided for @inputPhoneUsed.
  ///
  /// In zh, this message translates to:
  /// **'此門號已被註冊'**
  String get inputPhoneUsed;

  /// No description provided for @inputPhoneFormatInvalid.
  ///
  /// In zh, this message translates to:
  /// **'無效的電話格式'**
  String get inputPhoneFormatInvalid;

  /// No description provided for @verifyPhoneStepTitle.
  ///
  /// In zh, this message translates to:
  /// **'手機驗證'**
  String get verifyPhoneStepTitle;

  /// No description provided for @verifyPhoneSentTo.
  ///
  /// In zh, this message translates to:
  /// **'已傳送驗證碼至'**
  String get verifyPhoneSentTo;

  /// No description provided for @verifyPhoneFieldHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入驗證碼'**
  String get verifyPhoneFieldHint;

  /// No description provided for @resendCodeBtn.
  ///
  /// In zh, this message translates to:
  /// **'重發驗證碼'**
  String get resendCodeBtn;

  /// No description provided for @resendCode.
  ///
  /// In zh, this message translates to:
  /// **'可於 {time} 後重新發送驗證碼'**
  String resendCode(String time);

  /// No description provided for @cantReceiveCode.
  ///
  /// In zh, this message translates to:
  /// **'無法收到簡訊驗證碼? 聯繫客服協助'**
  String get cantReceiveCode;

  /// No description provided for @resetPasswordStepTitle.
  ///
  /// In zh, this message translates to:
  /// **'重設密碼'**
  String get resetPasswordStepTitle;

  /// No description provided for @yourPhoneNumber.
  ///
  /// In zh, this message translates to:
  /// **'您的手機門號'**
  String get yourPhoneNumber;

  /// No description provided for @setNewPassword.
  ///
  /// In zh, this message translates to:
  /// **'請輸入密碼'**
  String get setNewPassword;

  /// No description provided for @setNewPasswordFieldHint.
  ///
  /// In zh, this message translates to:
  /// **'設定新密碼'**
  String get setNewPasswordFieldHint;

  /// No description provided for @confirmPasswordFieldHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入密碼'**
  String get confirmPasswordFieldHint;

  /// No description provided for @passwordRequirement.
  ///
  /// In zh, this message translates to:
  /// **'長度8~20字元，需包含英文字母及數字'**
  String get passwordRequirement;

  /// No description provided for @home.
  ///
  /// In zh, this message translates to:
  /// **'首頁'**
  String get home;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'站點'**
  String get search;

  /// No description provided for @rewards.
  ///
  /// In zh, this message translates to:
  /// **'兌換'**
  String get rewards;

  /// No description provided for @profile.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get profile;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'是否確認登出'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In zh, this message translates to:
  /// **'將自動跳轉至註冊登入頁面'**
  String get logoutConfirmMessage;

  /// No description provided for @latestActivities.
  ///
  /// In zh, this message translates to:
  /// **'最新活動'**
  String get latestActivities;

  /// No description provided for @termsAgreementPrefix.
  ///
  /// In zh, this message translates to:
  /// **'我同意遵守 ECOCO的 '**
  String get termsAgreementPrefix;

  /// No description provided for @termsAgreementAnd.
  ///
  /// In zh, this message translates to:
  /// **' 及 '**
  String get termsAgreementAnd;

  /// No description provided for @termsOfService.
  ///
  /// In zh, this message translates to:
  /// **'服務條款及隱私權政策'**
  String get termsOfService;

  /// No description provided for @profilePhoto.
  ///
  /// In zh, this message translates to:
  /// **'個人照片'**
  String get profilePhoto;

  /// No description provided for @profilePhotoSelectedException.
  ///
  /// In zh, this message translates to:
  /// **'選擇照片時發生錯誤'**
  String get profilePhotoSelectedException;

  /// No description provided for @profilePhotoChoose.
  ///
  /// In zh, this message translates to:
  /// **'選擇照片來源'**
  String get profilePhotoChoose;

  /// No description provided for @camera.
  ///
  /// In zh, this message translates to:
  /// **'相機'**
  String get camera;

  /// No description provided for @photoAlbum.
  ///
  /// In zh, this message translates to:
  /// **'相簿'**
  String get photoAlbum;

  /// No description provided for @editProfile.
  ///
  /// In zh, this message translates to:
  /// **'編輯個人資料'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'儲存'**
  String get save;

  /// No description provided for @okay.
  ///
  /// In zh, this message translates to:
  /// **'確定'**
  String get okay;

  /// No description provided for @points.
  ///
  /// In zh, this message translates to:
  /// **'點'**
  String get points;

  /// No description provided for @kg.
  ///
  /// In zh, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @change.
  ///
  /// In zh, this message translates to:
  /// **'變更'**
  String get change;

  /// No description provided for @serviceTermTitle.
  ///
  /// In zh, this message translates to:
  /// **'服務條款'**
  String get serviceTermTitle;

  /// No description provided for @privacyTermTitle.
  ///
  /// In zh, this message translates to:
  /// **'隱私權政策'**
  String get privacyTermTitle;

  /// No description provided for @pointsTransferTitle.
  ///
  /// In zh, this message translates to:
  /// **'點數贈予'**
  String get pointsTransferTitle;

  /// No description provided for @pointsTransferAvaliable.
  ///
  /// In zh, this message translates to:
  /// **'可用的ECOCO點數'**
  String get pointsTransferAvaliable;

  /// No description provided for @pointsTransferCount.
  ///
  /// In zh, this message translates to:
  /// **'輸入欲轉贈的ECOCO點數數量'**
  String get pointsTransferCount;

  /// No description provided for @pointsTransferCountZeroMsg.
  ///
  /// In zh, this message translates to:
  /// **'請輸入點數'**
  String get pointsTransferCountZeroMsg;

  /// No description provided for @pointsTransferConfirm.
  ///
  /// In zh, this message translates to:
  /// **'確認贈送資訊'**
  String get pointsTransferConfirm;

  /// No description provided for @pointsTransferConfirmMsg.
  ///
  /// In zh, this message translates to:
  /// **'請再次確認受贈者手機號碼及欲轉贈的點數數量是否正確，贈送後將無法再返還'**
  String get pointsTransferConfirmMsg;

  /// No description provided for @pointsTransferHint.
  ///
  /// In zh, this message translates to:
  /// **'欲轉贈的ECOCO點數'**
  String get pointsTransferHint;

  /// No description provided for @pointsTransferRecvPhone.
  ///
  /// In zh, this message translates to:
  /// **'轉贈門號'**
  String get pointsTransferRecvPhone;

  /// No description provided for @pointsTransferRecvPhone2.
  ///
  /// In zh, this message translates to:
  /// **'請輸入手機號碼'**
  String get pointsTransferRecvPhone2;

  /// No description provided for @pointsTransferRecvHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入對方註冊於ECOCO的手機門號'**
  String get pointsTransferRecvHint;

  /// No description provided for @pointsTransferOTPHints.
  ///
  /// In zh, this message translates to:
  /// **'轉贈前須取得簡訊驗證碼，並進行驗證'**
  String get pointsTransferOTPHints;

  /// No description provided for @pointsTransferOTPMsg.
  ///
  /// In zh, this message translates to:
  /// **'請輸入OTP簡訊驗證碼'**
  String get pointsTransferOTPMsg;

  /// No description provided for @pointsTransferDoubleConfirm.
  ///
  /// In zh, this message translates to:
  /// **'確定轉贈'**
  String get pointsTransferDoubleConfirm;

  /// No description provided for @pointsTransferManualTitle.
  ///
  /// In zh, this message translates to:
  /// **'注意事項'**
  String get pointsTransferManualTitle;

  /// No description provided for @pointsTransferManual1.
  ///
  /// In zh, this message translates to:
  /// **'1. 每日23:50~00:10配合ECOCO點數清算作業，請避免於此時段進行點數轉贈，以避免權益受損。'**
  String get pointsTransferManual1;

  /// No description provided for @pointsTransferManual2.
  ///
  /// In zh, this message translates to:
  /// **'2. 轉贈功能僅限ECOCO會員使用，受贈對象須為ECOCO已註冊會員才能進行轉贈作業。'**
  String get pointsTransferManual2;

  /// No description provided for @pointsTransferManual3.
  ///
  /// In zh, this message translates to:
  /// **'3. 轉贈作業一經申請，恕不得要求取消、不得要求返還點數。'**
  String get pointsTransferManual3;

  /// No description provided for @pointsTransferManual4.
  ///
  /// In zh, this message translates to:
  /// **'4. 轉贈作業將於提交申請後10分鐘內完成，可於點數歷程中查詢。'**
  String get pointsTransferManual4;

  /// No description provided for @pointsTransferManual5.
  ///
  /// In zh, this message translates to:
  /// **'5. 轉贈之ECOCO點數有效期限與轉贈前相同。'**
  String get pointsTransferManual5;

  /// No description provided for @pointsTransferManual6.
  ///
  /// In zh, this message translates to:
  /// **'6. 每月僅能提交至多3筆轉贈申請，每次轉贈上限為1000點。'**
  String get pointsTransferManual6;

  /// No description provided for @pointsHistory.
  ///
  /// In zh, this message translates to:
  /// **'點數歷程'**
  String get pointsHistory;

  /// No description provided for @pointsHistory2.
  ///
  /// In zh, this message translates to:
  /// **'獲得紀錄'**
  String get pointsHistory2;

  /// No description provided for @pointsHistory3.
  ///
  /// In zh, this message translates to:
  /// **'使用紀錄'**
  String get pointsHistory3;

  /// No description provided for @pointsExchange.
  ///
  /// In zh, this message translates to:
  /// **'立即兌換'**
  String get pointsExchange;

  /// No description provided for @pet.
  ///
  /// In zh, this message translates to:
  /// **'PET 寶特瓶'**
  String get pet;

  /// No description provided for @pet2.
  ///
  /// In zh, this message translates to:
  /// **'寶特瓶'**
  String get pet2;

  /// No description provided for @hdpe.
  ///
  /// In zh, this message translates to:
  /// **'HDPE 牛奶瓶'**
  String get hdpe;

  /// No description provided for @hdpe2.
  ///
  /// In zh, this message translates to:
  /// **'HDPE瓶'**
  String get hdpe2;

  /// No description provided for @pp.
  ///
  /// In zh, this message translates to:
  /// **'PP 飲料杯'**
  String get pp;

  /// No description provided for @alu.
  ///
  /// In zh, this message translates to:
  /// **'鋁罐'**
  String get alu;

  /// No description provided for @aluRecycle.
  ///
  /// In zh, this message translates to:
  /// **'鋁罐'**
  String get aluRecycle;

  /// No description provided for @glass.
  ///
  /// In zh, this message translates to:
  /// **'玻璃瓶'**
  String get glass;

  /// No description provided for @battery.
  ///
  /// In zh, this message translates to:
  /// **'電池'**
  String get battery;

  /// No description provided for @other.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get other;

  /// No description provided for @bioActivate.
  ///
  /// In zh, this message translates to:
  /// **'啟用生物辨識'**
  String get bioActivate;

  /// No description provided for @bioActivate2.
  ///
  /// In zh, this message translates to:
  /// **'啟用生物辨識登入'**
  String get bioActivate2;

  /// No description provided for @bioActivateMsg.
  ///
  /// In zh, this message translates to:
  /// **'您是否要啟用生物辨識？'**
  String get bioActivateMsg;

  /// No description provided for @notificationTitle.
  ///
  /// In zh, this message translates to:
  /// **'APP推播'**
  String get notificationTitle;

  /// No description provided for @notificationTitleAnouncement.
  ///
  /// In zh, this message translates to:
  /// **'ECOCO公告'**
  String get notificationTitleAnouncement;

  /// No description provided for @notificationTitleSiteNews.
  ///
  /// In zh, this message translates to:
  /// **'站點消息'**
  String get notificationTitleSiteNews;

  /// No description provided for @notificationTitleActivity.
  ///
  /// In zh, this message translates to:
  /// **'活動資訊'**
  String get notificationTitleActivity;

  /// No description provided for @notificationBiz.
  ///
  /// In zh, this message translates to:
  /// **'商家優惠'**
  String get notificationBiz;

  /// No description provided for @notificationPointsExpiry.
  ///
  /// In zh, this message translates to:
  /// **'點數到期通知'**
  String get notificationPointsExpiry;

  /// No description provided for @notificationTicketExpiry.
  ///
  /// In zh, this message translates to:
  /// **'票券到期通知'**
  String get notificationTicketExpiry;

  /// No description provided for @notificationActivateTitle.
  ///
  /// In zh, this message translates to:
  /// **'開啟APP通知'**
  String get notificationActivateTitle;

  /// No description provided for @notificationSettingTitle.
  ///
  /// In zh, this message translates to:
  /// **'APP推播設定'**
  String get notificationSettingTitle;

  /// No description provided for @notificationStatusEnabled.
  ///
  /// In zh, this message translates to:
  /// **'已開啟'**
  String get notificationStatusEnabled;

  /// No description provided for @notificationStatusDisabled.
  ///
  /// In zh, this message translates to:
  /// **'已關閉'**
  String get notificationStatusDisabled;

  /// No description provided for @notificationSetting.
  ///
  /// In zh, this message translates to:
  /// **'通知設定'**
  String get notificationSetting;

  /// No description provided for @notificationEmailTitle.
  ///
  /// In zh, this message translates to:
  /// **'Email電子報'**
  String get notificationEmailTitle;

  /// No description provided for @notificationEmailTitleActivity.
  ///
  /// In zh, this message translates to:
  /// **'活動優惠'**
  String get notificationEmailTitleActivity;

  /// No description provided for @notificationEmailTitleSurvey.
  ///
  /// In zh, this message translates to:
  /// **'線上問卷調查'**
  String get notificationEmailTitleSurvey;

  /// No description provided for @priviledgeSetting.
  ///
  /// In zh, this message translates to:
  /// **'權限設定'**
  String get priviledgeSetting;

  /// No description provided for @qaTitle.
  ///
  /// In zh, this message translates to:
  /// **'常見問題'**
  String get qaTitle;

  /// No description provided for @contactUs.
  ///
  /// In zh, this message translates to:
  /// **'聯絡我們'**
  String get contactUs;

  /// No description provided for @rightProblem.
  ///
  /// In zh, this message translates to:
  /// **'權益相關'**
  String get rightProblem;

  /// No description provided for @rightProblemPoints.
  ///
  /// In zh, this message translates to:
  /// **'ECOCO點數使用辦法'**
  String get rightProblemPoints;

  /// No description provided for @rightProblemTerm.
  ///
  /// In zh, this message translates to:
  /// **'使用者條款'**
  String get rightProblemTerm;

  /// No description provided for @rightProblemPrivacy.
  ///
  /// In zh, this message translates to:
  /// **'個資與隱私權保護政策'**
  String get rightProblemPrivacy;

  /// No description provided for @rightProblemDeleteAccoint.
  ///
  /// In zh, this message translates to:
  /// **'刪除帳號'**
  String get rightProblemDeleteAccoint;

  /// No description provided for @manual.
  ///
  /// In zh, this message translates to:
  /// **'使用教學'**
  String get manual;

  /// No description provided for @knownUs.
  ///
  /// In zh, this message translates to:
  /// **'認識ECOCO'**
  String get knownUs;

  /// No description provided for @likeUs.
  ///
  /// In zh, this message translates to:
  /// **'按讚追蹤'**
  String get likeUs;

  /// No description provided for @systemVersion.
  ///
  /// In zh, this message translates to:
  /// **'版本資訊'**
  String get systemVersion;

  /// No description provided for @appVersion.
  ///
  /// In zh, this message translates to:
  /// **'版本資訊'**
  String get appVersion;

  /// No description provided for @phoneVersion.
  ///
  /// In zh, this message translates to:
  /// **'作業系統'**
  String get phoneVersion;

  /// No description provided for @phoneModel.
  ///
  /// In zh, this message translates to:
  /// **'裝置型號'**
  String get phoneModel;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In zh, this message translates to:
  /// **'確認刪除帳號'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMsg.
  ///
  /// In zh, this message translates to:
  /// **'您確定要刪除帳號嗎？\n此操作無法復原。'**
  String get deleteAccountMsg;

  /// No description provided for @deleteAccountPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'刪除ECOCO帳號'**
  String get deleteAccountPageTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In zh, this message translates to:
  /// **'警告：刪除帳號後，所有點數與優惠券將失效，並清除累積紀錄，操作不可復原'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountPasswordTitle.
  ///
  /// In zh, this message translates to:
  /// **'請輸入密碼以驗證身份'**
  String get deleteAccountPasswordTitle;

  /// No description provided for @deleteAccountPasswordHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入密碼'**
  String get deleteAccountPasswordHint;

  /// No description provided for @deleteAccountPasswordError.
  ///
  /// In zh, this message translates to:
  /// **'密碼輸入錯誤,請重新輸入'**
  String get deleteAccountPasswordError;

  /// No description provided for @deleteAccountReasonTitle.
  ///
  /// In zh, this message translates to:
  /// **'為什麼想要刪除帳號'**
  String get deleteAccountReasonTitle;

  /// No description provided for @deleteAccountReasonRequired.
  ///
  /// In zh, this message translates to:
  /// **'請選擇刪除原因'**
  String get deleteAccountReasonRequired;

  /// No description provided for @deleteAccountReason1.
  ///
  /// In zh, this message translates to:
  /// **'回收站點不方便或太遠'**
  String get deleteAccountReason1;

  /// No description provided for @deleteAccountReason1Sub1.
  ///
  /// In zh, this message translates to:
  /// **'站點離我家或公司太遠'**
  String get deleteAccountReason1Sub1;

  /// No description provided for @deleteAccountReason1Sub2.
  ///
  /// In zh, this message translates to:
  /// **'站點機器常故障或無法投遞'**
  String get deleteAccountReason1Sub2;

  /// No description provided for @deleteAccountReason1Sub3.
  ///
  /// In zh, this message translates to:
  /// **'要花太長時間操作機台'**
  String get deleteAccountReason1Sub3;

  /// No description provided for @deleteAccountReason1Sub4.
  ///
  /// In zh, this message translates to:
  /// **'其他站點相關問題'**
  String get deleteAccountReason1Sub4;

  /// No description provided for @deleteAccountReason2.
  ///
  /// In zh, this message translates to:
  /// **'點數太少,獎勵不吸引我'**
  String get deleteAccountReason2;

  /// No description provided for @deleteAccountReason2Sub1.
  ///
  /// In zh, this message translates to:
  /// **'點數累積速度太慢'**
  String get deleteAccountReason2Sub1;

  /// No description provided for @deleteAccountReason2Sub2.
  ///
  /// In zh, this message translates to:
  /// **'優惠券或商品種類太少'**
  String get deleteAccountReason2Sub2;

  /// No description provided for @deleteAccountReason2Sub3.
  ///
  /// In zh, this message translates to:
  /// **'兌換的商品價值太低/吸引力不足'**
  String get deleteAccountReason2Sub3;

  /// No description provided for @deleteAccountReason2Sub4.
  ///
  /// In zh, this message translates to:
  /// **'兌換門檻太高,很難達到東西'**
  String get deleteAccountReason2Sub4;

  /// No description provided for @deleteAccountReason3.
  ///
  /// In zh, this message translates to:
  /// **'APP體驗不佳或有Bug'**
  String get deleteAccountReason3;

  /// No description provided for @deleteAccountReason3Sub1.
  ///
  /// In zh, this message translates to:
  /// **'APP 經常當機、閃退或速度慢'**
  String get deleteAccountReason3Sub1;

  /// No description provided for @deleteAccountReason3Sub2.
  ///
  /// In zh, this message translates to:
  /// **'回收或兌換流程太複雜'**
  String get deleteAccountReason3Sub2;

  /// No description provided for @deleteAccountReason3Sub3.
  ///
  /// In zh, this message translates to:
  /// **'點數顯示或交易紀錄有錯誤'**
  String get deleteAccountReason3Sub3;

  /// No description provided for @deleteAccountReason3Sub4.
  ///
  /// In zh, this message translates to:
  /// **'通知訊息太多/太少/不準確'**
  String get deleteAccountReason3Sub4;

  /// No description provided for @deleteAccountReason3Sub5.
  ///
  /// In zh, this message translates to:
  /// **'其他APP相關問題'**
  String get deleteAccountReason3Sub5;

  /// No description provided for @deleteAccountReason4.
  ///
  /// In zh, this message translates to:
  /// **'很少使用,不再需要'**
  String get deleteAccountReason4;

  /// No description provided for @deleteAccountReason4Sub1.
  ///
  /// In zh, this message translates to:
  /// **'我的生活模式改變,不常回收了'**
  String get deleteAccountReason4Sub1;

  /// No description provided for @deleteAccountReason4Sub2.
  ///
  /// In zh, this message translates to:
  /// **'我主要使用其他類似的回收服務'**
  String get deleteAccountReason4Sub2;

  /// No description provided for @deleteAccountReason4Sub3.
  ///
  /// In zh, this message translates to:
  /// **'只是測試或體驗嘗試而已'**
  String get deleteAccountReason4Sub3;

  /// No description provided for @deleteAccountReason5.
  ///
  /// In zh, this message translates to:
  /// **'其他原因'**
  String get deleteAccountReason5;

  /// No description provided for @deleteAccountReason5Sub1.
  ///
  /// In zh, this message translates to:
  /// **'擔心隱私或資料安全問題'**
  String get deleteAccountReason5Sub1;

  /// No description provided for @deleteAccountReason5Sub2.
  ///
  /// In zh, this message translates to:
  /// **'不滿意客戶服務'**
  String get deleteAccountReason5Sub2;

  /// No description provided for @deleteAccountReason5Sub3.
  ///
  /// In zh, this message translates to:
  /// **'僅想提供意見,沒有特定選項'**
  String get deleteAccountReason5Sub3;

  /// No description provided for @deleteAccountFeedbackTitle.
  ///
  /// In zh, this message translates to:
  /// **'最後有什麼想建議ECOCO團隊嗎?'**
  String get deleteAccountFeedbackTitle;

  /// No description provided for @deleteAccountFeedbackHint.
  ///
  /// In zh, this message translates to:
  /// **'請輸入建議'**
  String get deleteAccountFeedbackHint;

  /// No description provided for @deleteAccountConsentText.
  ///
  /// In zh, this message translates to:
  /// **'我同意並了解我的所有帳號資料都將永久刪除'**
  String get deleteAccountConsentText;

  /// No description provided for @deleteAccountConsentRequired.
  ///
  /// In zh, this message translates to:
  /// **'請確認您同意刪除帳號'**
  String get deleteAccountConsentRequired;

  /// No description provided for @deleteAccountButton.
  ///
  /// In zh, this message translates to:
  /// **'刪除帳號'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountCancelButton.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get deleteAccountCancelButton;

  /// No description provided for @accountSecurity.
  ///
  /// In zh, this message translates to:
  /// **'帳號與安全'**
  String get accountSecurity;

  /// No description provided for @phoneVerificationStatus.
  ///
  /// In zh, this message translates to:
  /// **'手機驗證狀態'**
  String get phoneVerificationStatus;

  /// No description provided for @verified.
  ///
  /// In zh, this message translates to:
  /// **'已驗證'**
  String get verified;

  /// No description provided for @lineBindingStatus.
  ///
  /// In zh, this message translates to:
  /// **'Line綁定狀態'**
  String get lineBindingStatus;

  /// No description provided for @goToBind.
  ///
  /// In zh, this message translates to:
  /// **'前往綁定'**
  String get goToBind;

  /// No description provided for @requestDeleteAccount.
  ///
  /// In zh, this message translates to:
  /// **'申請刪除帳號'**
  String get requestDeleteAccount;

  /// No description provided for @siteSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜尋站點'**
  String get siteSearchHint;

  /// No description provided for @siteSearchHint2.
  ///
  /// In zh, this message translates to:
  /// **'搜尋站點名稱'**
  String get siteSearchHint2;

  /// No description provided for @siteAreaSelection.
  ///
  /// In zh, this message translates to:
  /// **'選擇地區'**
  String get siteAreaSelection;

  /// No description provided for @siteAreaSelectionClear.
  ///
  /// In zh, this message translates to:
  /// **'清除地區選擇'**
  String get siteAreaSelectionClear;

  /// No description provided for @siteFav.
  ///
  /// In zh, this message translates to:
  /// **'常用'**
  String get siteFav;

  /// No description provided for @siteInActivity.
  ///
  /// In zh, this message translates to:
  /// **'活動中'**
  String get siteInActivity;

  /// No description provided for @siteUpdateFailed.
  ///
  /// In zh, this message translates to:
  /// **'更新收藏站點失敗'**
  String get siteUpdateFailed;

  /// No description provided for @siteFavoriteLimitReached.
  ///
  /// In zh, this message translates to:
  /// **'已達收藏上限，最多可收藏5個站點'**
  String get siteFavoriteLimitReached;

  /// No description provided for @siteTypeGroupedBin.
  ///
  /// In zh, this message translates to:
  /// **'混合回收桶（AI機/方舟）'**
  String get siteTypeGroupedBin;

  /// No description provided for @siteTypeSeparateBin.
  ///
  /// In zh, this message translates to:
  /// **'分類回收桶（H30/集過來）'**
  String get siteTypeSeparateBin;

  /// No description provided for @recyclableItemPetBottle.
  ///
  /// In zh, this message translates to:
  /// **'PET 寶特瓶'**
  String get recyclableItemPetBottle;

  /// No description provided for @recyclableItemAluminumCan.
  ///
  /// In zh, this message translates to:
  /// **'鐵鋁罐'**
  String get recyclableItemAluminumCan;

  /// No description provided for @recyclableItemPpCup.
  ///
  /// In zh, this message translates to:
  /// **'PP 塑膠杯'**
  String get recyclableItemPpCup;

  /// No description provided for @recyclableItemHdpeBottle.
  ///
  /// In zh, this message translates to:
  /// **'HDPE 塑膠瓶'**
  String get recyclableItemHdpeBottle;

  /// No description provided for @recyclableItemBattery.
  ///
  /// In zh, this message translates to:
  /// **'電池'**
  String get recyclableItemBattery;

  /// No description provided for @publicBenefitMerchants.
  ///
  /// In zh, this message translates to:
  /// **'公益商家'**
  String get publicBenefitMerchants;

  /// No description provided for @howToRedeem.
  ///
  /// In zh, this message translates to:
  /// **'如何兌換優惠'**
  String get howToRedeem;

  /// No description provided for @featuredOffers.
  ///
  /// In zh, this message translates to:
  /// **'精選優惠'**
  String get featuredOffers;

  /// No description provided for @moreOffers.
  ///
  /// In zh, this message translates to:
  /// **'更多優惠'**
  String get moreOffers;

  /// No description provided for @sortByDefault.
  ///
  /// In zh, this message translates to:
  /// **'綜合排序'**
  String get sortByDefault;

  /// No description provided for @sortByPointsDesc.
  ///
  /// In zh, this message translates to:
  /// **'點數排序 ↓'**
  String get sortByPointsDesc;

  /// No description provided for @sortByPointsAsc.
  ///
  /// In zh, this message translates to:
  /// **'點數排序 ↑'**
  String get sortByPointsAsc;

  /// No description provided for @endOfList.
  ///
  /// In zh, this message translates to:
  /// **'到底囉～敬請期待更多優惠'**
  String get endOfList;

  /// No description provided for @backToTop.
  ///
  /// In zh, this message translates to:
  /// **'回到頂部'**
  String get backToTop;

  /// No description provided for @registrationSessionExpiredTitle.
  ///
  /// In zh, this message translates to:
  /// **'驗證已過期'**
  String get registrationSessionExpiredTitle;

  /// No description provided for @registrationSessionExpiredMessage.
  ///
  /// In zh, this message translates to:
  /// **'您的驗證已逾時失效，請重新進行手機驗證'**
  String get registrationSessionExpiredMessage;

  /// No description provided for @restartVerification.
  ///
  /// In zh, this message translates to:
  /// **'重新驗證'**
  String get restartVerification;

  /// No description provided for @registrationFailed.
  ///
  /// In zh, this message translates to:
  /// **'註冊失敗'**
  String get registrationFailed;

  /// No description provided for @registrationError.
  ///
  /// In zh, this message translates to:
  /// **'註冊過程中發生錯誤，請稍後再試'**
  String get registrationError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
