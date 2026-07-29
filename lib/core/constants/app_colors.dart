import 'package:flutter/material.dart';

/// centralized app color constants matching malamal.com.bd brand palette
class AppColors {
  // primary brand colors
  static const Color primary = Color(0xFFF04F23); // orange-red brand color
  static const Color primaryLight = Color(0xFFFFCCBC);
  static const Color primaryDark = Color(0xFFD83C12);

  // accent / secondary colors
  static const Color secondary = Color(0xFF112240); // navy blue brand color
  static const Color secondaryAccent = Color(
    0xFFFFD54F,
  ); // yellow for promotions
  static const Color whatsapp = Color(0xFF25D366); // whatsapp green color

  // neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF212121);
  static const Color greyLight = Color(0xFFF9F9F9);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF424242);
  static const Color greyBorder = Color(0xFFE0E0E0);

  // state colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ui utility colors
  static const Color scaffold = Color(0xFFF5F5F5); // scaffold background
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color discount = Color(0xFFE53935); // discount badge red
  static const Color shimmer = Color(0xFFE0E0E0); // shimmer placeholder
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // transparent
  static const Color transparent = Colors.transparent;
}
