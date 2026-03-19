import 'package:flutter/material.dart';

class AppColors {
  static const Color formFieldBackground = Color.fromARGB(255, 239, 241, 245);
  static const Color formFieldValidBackground = Color.fromARGB(255, 217, 235, 255);
  static const Color formFieldInvalidBackground = Color.fromARGB(255, 250, 207, 207);

  // Primary and accent colors
  static const Color primaryHighlightColor = Color(0xFFFF5000);
  static const Color primaryDisabledColor = Color(0xFFFFFFFF);
  static const Color secondaryHighlightColor = Color(0xFFFFCE00);
  static const Color greyBackground = Color(0xFFF2F2F2);
  static const Color whiteBackground = Colors.white;
  static const Color tabBackground = greyBackground;
  static const Color orangeBackground = Color(0xFFFF5000);
  static const Color secondaryTextColor = Color(0xFF333333);
  static const Color secondaryValueColor = Color(0xFF808080);
  static const Color thirdValueColor = Color(0xFFD9D9D9);
  static const Color formFieldErrorBorder = Color(0xFFD10000);
  static const Color textCursorColor = Color(0xFF060E9F);
  static const Color snackbarBackgroundColor = Color(0xFF333333);
  static const Color appBackgroundColor = Color(0xFFF7F7F7);

  static const Color indicatorColor = Color(0xFF0076A9);
  static const Color dakaCoinColor = Color(0xFF00A82D);
  static const Color ntpCoinColor = Color(0xFF5CA9BA);
  static const Color couponBgColor = Color(0xFFB2B2B2);

  static const Color warningRed = Color(0xFFD10000);

  // Login page colors
  static const Color loginYellow = secondaryHighlightColor;
  static const Color loginOrange = Color(0xFFFF6B35);
  static const Color loginGray = Color(0xFF9E9E9E);
  static const Color loginButtonGray = Color(0xFFABABAB);
  static const Color loginButtonOrange = primaryHighlightColor;
  static const Color loginTextbutton = Color(0xFF0076A9);

  // Background colors
  static const Color backgroundYellow = secondaryHighlightColor;
  static const Color disabledButtomBackground = Color(0xFFABABAB);
  static const Color buttomBackground = primaryHighlightColor;

  // Button colors for terms dialog
  static const Color termsAgreeButton = loginOrange; // Orange for agree/confirm
  static const Color termsDisagreeButton = loginTextbutton; // Blue for disagree
  static const Color termsDisabledButton = loginButtonGray; // Gray for disabled state

  static const Color dividerColor = Color(0xFFF2F2F2);
  static const Color inputBorderColor = Color(0xFF808080);

  // Station card colors
  static const Color stationHeaderBlue = Color(0xFF1E40AF); // Deep blue header
  static const Color stationGreenBadge = Color(0xFF00A82D); // Green "可投" badge
  static const Color stationGrayBadge = Color(0xFF9D9D9D); // Gray "休息中"/"維護中" badge
  static const Color stationIconGray = Color(0xFF9D9D9D); // Gray for disabled icons
  static const Color stationIconGreen = Color(0xFF10B981); // Green for active item icons
  static const Color stationDividerGray = Color(0xFFE5E7EB); // Light gray dividers
  static const Color stationTextGray = Color(0xFF6B7280); // Medium gray secondary text
  static const Color stationTextDark = Color(0xFF374151); // Dark gray primary text
  static const Color stationBookmarkOrange = Color(0xFFFB923C); // Orange bookmark/favorite
  static const Color stationBookmarkGray = Color(0xFF9D9D9D); // Gray bookmark outline
} 