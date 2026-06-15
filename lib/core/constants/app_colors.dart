import 'package:flutter/material.dart';

/// All brand colors used across the app.
///
/// Naming follows the design mockup tokens. Use these instead of
/// hard-coding hex values in widgets so we can re-skin the app easily.
class AppColors {
  AppColors._(); // prevent instantiation

  // ── Brand Blues ──────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFFE3F2FD);

  // ── Sidebar / Dark Surface ──────────────────────────────────
  static const Color darkNavy = Color(0xFF0F1923);
  static const Color darkNavyLight = Color(0xFF1A2332);
  static const Color darkNavyLighter = Color(0xFF243447);

  // ── Semantic Colors ─────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFFFFEBEE);

  // ── Neutrals ────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);

  // ── Text ────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xFF8899AA);

  // ── Gradients ───────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F1923), Color(0xFF1A2332)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
