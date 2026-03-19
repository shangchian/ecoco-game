import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '/constants/colors.dart';

class SystemUiStyleHelper {
  /// Default style for the main app (White background, Dark icons)
  /// Used in LoginPage, MainPage, etc.
  static const SystemUiOverlayStyle defaultStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android: Dark icons for light background
    statusBarBrightness: Brightness.light,    // iOS: Dark icons for light background
    systemNavigationBarColor: Colors.transparent,   // Transparent for edge-to-edge
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// Style for the Splash Screen (Orange background, Light icons)
  static const SystemUiOverlayStyle splashStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // Android: Light icons for dark/orange background
    statusBarBrightness: Brightness.dark,      // iOS: Light icons for dark/orange background
    systemNavigationBarColor: AppColors.primaryHighlightColor, // Orange
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// Style for Game Mode (Dark background, Light icons)
  static const SystemUiOverlayStyle gameStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFF121212),
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// Style for Game Mode - Light (White background, Dark icons)
  static const SystemUiOverlayStyle gameLightStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
