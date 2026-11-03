import 'package:flutter/material.dart';

/// Centralized ALCO color tokens as specified in design.md and prd.md.
class AppColors {
  AppColors._();

  /// Primary Green (#00351F) - Main headings, primary buttons, navigation emphasis
  static const Color primaryGreen = Color(0xFF00351F);

  /// Accent Lime (#91BE24) - Active indicators, icon accents, small highlights
  static const Color accentLime = Color(0xFF91BE24);

  /// App Background (#F5F7F4) - Main screen background
  static const Color appBackground = Color(0xFFF5F7F4);

  /// Surface (#FFFFFF) - Cards, app bars, input fields
  static const Color surface = Color(0xFFFFFFFF);

  /// Main Text (#153326) - Primary body text
  static const Color mainText = Color(0xFF153326);

  /// Secondary Text (#778078) - Supporting text and descriptions
  static const Color secondaryText = Color(0xFF778078);

  /// Border (#E3E8E3) - Card and input outlines
  static const Color border = Color(0xFFE3E8E3);

  /// Success (#2E7D32) - Successful actions and status
  static const Color success = Color(0xFF2E7D32);

  /// Error (#C62828) - Validation and error messages
  static const Color error = Color(0xFFC62828);
}

