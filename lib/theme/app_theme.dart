import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ── Pure Black & White Palette ────────────────────────────────────────────
  static const bg        = Color(0xFF0A0A0A);   // true near-black
  static const surface   = Color(0xFF111111);   // slightly lifted
  static const card      = Color(0xFF161616);   // card background
  static const border    = Color(0xFF252525);   // subtle border
  static const border2   = Color(0xFF333333);   // more visible border

  // Accent whites
  static const white     = Color(0xFFFFFFFF);   // pure white primary
  static const white90   = Color(0xFFE8E8E8);   // warm off-white
  static const muted     = Color(0xFF888888);   // muted grey
  static const faint     = Color(0xFF222222);   // barely-there surface

  // Semantic colours (minimal, desaturated)
  static const accent    = Color(0xFFFFFFFF);   // primary accent = white
  static const accentDim = Color(0xFF333333);   // dim version for backgrounds
  static const error     = Color(0xFFFF3B3B);   // only colour allowed = critical error

  // ── Removed colour tokens kept as aliases ─────────────────────────────────
  // All former "mint/violet/amber/rose" references now map to white/grey
  static const mint      = white;
  static const mintMid   = white90;
  static const mintDim   = muted;
  static const violet    = muted;
  static const violetMid = muted;
  static const sky       = white90;
  static const amber     = white90;
  static const rose      = error;
  static const lilac     = muted;
  static const faintTint = faint;

  // ── Backward-compat aliases ───────────────────────────────────────────────
  static const emerald       = white;
  static const emeraldLight  = white90;
  static const indigo        = muted;
  static const indigoLight   = muted;
  static const bgDark        = bg;
  static const surfaceDark   = surface;
  static const cardDark      = card;
  static const borderDark    = border;
  static const textPrimary   = white;
  static const textSecondary = muted;

  // ── Card helper ───────────────────────────────────────────────────────────
  static BoxDecoration cardBox({Color? color, bool glow = false, Color? glowColor}) {
    return BoxDecoration(
      color: color ?? card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border, width: 1),
    );
  }

  // ── Full Theme ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: bg,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: white,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary:    white,
        secondary:  muted,
        surface:    surface,
        onSurface:  white,
        onPrimary:  Colors.black,
        error:      error,
        onError:    Colors.white,
      ),
      // ── AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: muted, size: 22),
      ),
      // ── Card
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      // ── ElevatedButton → white pill with black text
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: Colors.black,
          disabledBackgroundColor: faint,
          disabledForegroundColor: muted,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.2),
        ),
      ),
      // ── OutlinedButton → white border ghost
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: white,
          side: const BorderSide(color: border2, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      // ── TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: white,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      // ── Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: muted, fontSize: 15),
        labelStyle: const TextStyle(color: muted, fontSize: 15),
        prefixIconColor: muted,
        suffixIconColor: muted,
        border:         OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: border)),
        enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: border)),
        focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: white, width: 1.5)),
        errorBorder:    OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: error)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      // ── Divider
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 0),
      // ── Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: white,
        inactiveTrackColor: faint,
        thumbColor: white,
        overlayColor: Colors.white.withValues(alpha: 0.08),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
      // ── ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: white,
        linearTrackColor: faint,
        circularTrackColor: faint,
      ),
      // ── ListTile
      listTileTheme: const ListTileThemeData(
        iconColor: muted,
        textColor: white,
        titleTextStyle: TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.w600),
        subtitleTextStyle: TextStyle(color: muted, fontSize: 12),
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme;
}
