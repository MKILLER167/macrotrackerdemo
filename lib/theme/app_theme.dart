import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ── Palette ──────────────────────────────────────────────────────────────
  static const bg        = Color(0xFF080E1A);   // near-black navy
  static const surface   = Color(0xFF0E1726);   // card base
  static const card      = Color(0xFF121F30);   // slightly elevated card
  static const border    = Color(0xFF1C2E44);   // subtle divider
  static const border2   = Color(0xFF243550);   // a bit more visible

  static const mint      = Color(0xFF00E5A0);   // neon mint primary
  static const mintMid   = Color(0xFF00C48C);   // mid shade
  static const mintDim   = Color(0xFF00A876);   // deeper

  static const violet    = Color(0xFF7B61FF);   // secondary violet
  static const violetMid = Color(0xFF6048E8);

  static const sky        = Color(0xFF38BDF8);   // Info blue
  static const amber      = Color(0xFFFBBF24);   // Warning amber
  static const rose       = Color(0xFFF43F5E);   // Error rose
  static const lilac      = Color(0xFFA78BFA);   // purple accent

  static const white  = Color(0xFFF0F8FF);       // text primary
  static const muted  = Color(0xFF7A96B0);       // text muted
  static const faint  = Color(0xFF2B4060);       // barely-there tint

  // ── Gradients (static shortcuts) ─────────────────────────────────────────
  static const mintGrad    = LinearGradient(colors: [mint, violet], begin: Alignment.topLeft,  end: Alignment.bottomRight);
  static const darkMintGrad= LinearGradient(colors: [mintMid, violet], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const nightGrad   = LinearGradient(colors: [Color(0xFF0E1726), Color(0xFF080E1A)], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  // ── Card decoration helper ─────────────────────────────────────────────────
  static BoxDecoration cardBox({Color? color, bool glow = false, Color? glowColor}) {
    return BoxDecoration(
      color: color ?? card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: border, width: 1),
      boxShadow: glow ? [
        BoxShadow(color: (glowColor ?? mint).withValues(alpha: 0.18), blurRadius: 24, spreadRadius: 0, offset: const Offset(0, 4)),
      ] : null,
    );
  }

  // ── Full Theme ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: mint,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary:    mint,
        secondary:  violet,
        surface:    surface,
        onSurface:  white,
        onPrimary:  Colors.black,
        error:      rose,
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
      // ── ElevatedButton → neon pill
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mint,
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
      // ── OutlinedButton → ghost border
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
          foregroundColor: mint,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: mint, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: rose)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      // ── Divider
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 0),
      // ── Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: mint,
        inactiveTrackColor: faint,
        thumbColor: Colors.white,
        overlayColor: mint.withValues(alpha: 0.12),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
      // ── ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: mint,
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

  // ── Backward-compatible aliases (old → new) ────────────────────────────────
  static const emerald      = mint;
  static const emeraldLight = mint;
  static const indigo       = violet;
  static const indigoLight  = violetMid;
  static const bgDark       = bg;
  static const surfaceDark  = surface;
  static const cardDark     = card;
  static const borderDark   = border;
  static const textPrimary  = white;
  static const textSecondary = muted;
}
