import 'package:flutter/material.dart';

/// AppColors defines the visual color identity for ReThread.
/// 
/// The color palette is selected to reflect an environmentally conscious,
/// modern, and clean aesthetic:
/// - Forest Green (Primary): Growth, renewal, sustainability.
/// - Sage Green (Secondary): Balance, nature, soft accent.
/// - Warm Off-White (Background): Approachable, comfortable reading canvas.
/// - Muted Orange (Accent): Warm call-to-action highlights without aggressive alert reds.
/// - Charcoal (Text): High-contrast, accessible readability.
abstract class AppColors {
  // Primary & Secondary Brand Colors
  static const Color primary = Color(0xFF1B4D3E); // Deep Forest Green
  static const Color primaryLight = Color(0xFF2E6B56);
  static const Color primaryDark = Color(0xFF0F3227);

  static const Color secondary = Color(0xFF8A9A86); // Sage Green
  static const Color secondaryLight = Color(0xFFA5B4A1);
  static const Color secondaryDark = Color(0xFF6B7B68);

  // Background & Surfaces
  static const Color background = Color(0xFFF9F9F6); // Warm Off-White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2ED);

  // Accent Colors
  static const Color accent = Color(0xFFE07A5F); // Muted Orange
  static const Color accentLight = Color(0xFFF29B83);

  // Text Colors
  static const Color textPrimary = Color(0xFF212529); // Dark Charcoal
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textMuted = Color(0xFF9E9E9E);

  // Functional / Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Card & Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFECEFF1);
}
