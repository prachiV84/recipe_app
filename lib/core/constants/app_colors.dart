import 'package:flutter/material.dart';

// App color constants for consistent theming throughout the app
class AppColors {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFFF8C00);
  static const Color primaryPurple = Color.fromARGB(255, 204, 172, 226);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color darkGrey = Color(0xFF212121);
  static const Color mediumGrey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color veryLightGrey = Color(0xFFEEEEEE);

  // Chip Colors
  static const Color chipBackground = Color(0xFFF5F5F5);
  static const Color chipBorder = Color.fromARGB(255, 194, 144, 226);
  static const Color chipText = Color(0xFF424242);
  static const Color activeChipBackground = Color(0xFFFF8C00);
  static const Color activeChipText = Colors.white;

  // Gradient Colors
  static const List<Color> topGradient = [
    Color.fromARGB(153, 0, 0, 0),
    Color.fromARGB(51, 0, 0, 0),
  ];

  static const List<Color> bottomGradient = [
    Colors.transparent,
    Color.fromARGB(138, 0, 0, 0),
  ];

  // Favorite/Heart Colors
  static const Color favoriteRed = Colors.red;
  static const Color notFavouriteGrey = Color(0xFFBDBDBD);

  // Accent Colors
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);

  // UI Colors
  static const Color transparent = Colors.transparent;
  static const Color tabIndicator = Color(0xFFFF8C00);
  static const Color tabLabelColor = Color(0xFF212121);
  static const Color tabUnselectedColor = Color(0xFF9E9E9E);
  static const Color skeletonBg = Color(0xFFE0E0E0);
  static const Color skeletonShimmer1 = Color(0xFFF5F5F5);
  static const Color skeletonShimmer2 = Color(0xFFEEEEEE);
  static const Color checkIconColor = Color(0xFF388E3C);
  static const Color borderColor = Color(0xFFC290E2);
  static const Color greyText = Color(0xFF616161);
  static const Color lightGreyText = Color(0xFF9E9E9E);
}
