// lib/src/core/utils/screen_size.dart
import 'package:flutter/material.dart';

class ScreenSize {
  static double _screenWidth = 0.0;
  static double _screenHeight = 0.0;

  static void initialize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
}