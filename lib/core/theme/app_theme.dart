import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6366F1); // Indigo / Iris
  static const Color secondaryColor = Color(0xFF8B5CF6); // Violet
  static const Color accentColor = Color(0xFF06B6D4); // Electric Cyan
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color warningColor = Color(0xFFF59E0B); // Warm Amber
  static const Color errorColor = Color(0xFFEF4444); // Crimson

  // Light Surfaces
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightOnSurface = Color(0xFF0F172A);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);

  // Dark Surfaces
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF131A29);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);

  // AMOLED Surfaces (Pitch Black #000000)
  static const Color amoledBackground = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF0A0A0A);
  static const Color amoledSurfaceVariant = Color(0xFF141414);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const LinearGradient focusGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
  );

  static const LinearGradient energyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x22FFFFFF), Color(0x08FFFFFF)],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: lightSurface,
        onSurface: lightOnSurface,
      ).copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: lightSurface,
        surfaceContainerHighest: lightSurfaceVariant,
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnSurfaceVariant,
        error: errorColor,
      ),
      scaffoldBackgroundColor: lightBackground,
      textTheme: _buildTextTheme(isLight: true),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: lightOnSurface,
        ),
        iconTheme: const IconThemeData(color: lightOnSurface),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      extensions: const [
        AppColors.light,
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: darkSurface,
        onSurface: darkOnSurface,
      ).copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: darkSurface,
        surfaceContainerHighest: darkSurfaceVariant,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurfaceVariant,
        error: errorColor,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: _buildTextTheme(isLight: false),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: darkOnSurface,
        ),
        iconTheme: const IconThemeData(color: darkOnSurface),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      extensions: const [
        AppColors.dark,
      ],
    );
  }

  static ThemeData get amoledTheme {
    return darkTheme.copyWith(
      scaffoldBackgroundColor: amoledBackground,
      colorScheme: darkTheme.colorScheme.copyWith(
        surface: amoledSurface,
        surfaceContainerHighest: amoledSurfaceVariant,
      ),
      cardTheme: CardThemeData(
        color: amoledSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      extensions: const [
        AppColors.amoled,
      ],
    );
  }

  static TextTheme _buildTextTheme({required bool isLight}) {
    final baseColor = isLight ? lightOnSurface : darkOnSurface;
    final subtleColor = isLight ? lightOnSurfaceVariant : darkOnSurfaceVariant;

    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        color: baseColor,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: -1.0,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: baseColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: subtleColor,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: subtleColor,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: subtleColor,
        letterSpacing: 0.5,
      ),
    );
  }
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.cardGlass,
    required this.cardGlassBorder,
    required this.navBar,
    required this.navBarBorder,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.noteCard1,
    required this.noteCard2,
    required this.noteCard3,
    required this.noteCard4,
    required this.noteCard5,
  });

  final Color cardGlass;
  final Color cardGlassBorder;
  final Color navBar;
  final Color navBarBorder;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color noteCard1;
  final Color noteCard2;
  final Color noteCard3;
  final Color noteCard4;
  final Color noteCard5;

  static const AppColors light = AppColors(
    cardGlass: Color(0xCCFFFFFF),
    cardGlassBorder: Color(0x336366F1),
    navBar: Color(0xEEFFFFFF),
    navBarBorder: Color(0x1A6366F1),
    shimmerBase: Color(0xFFE2E8F0),
    shimmerHighlight: Color(0xFFF1F5F9),
    noteCard1: Color(0xFFEEF2FF),
    noteCard2: Color(0xFFF0FDF4),
    noteCard3: Color(0xFFFFF7ED),
    noteCard4: Color(0xFFFDF4FF),
    noteCard5: Color(0xFFEFF6FF),
  );

  static const AppColors dark = AppColors(
    cardGlass: Color(0xCC131A29),
    cardGlassBorder: Color(0x336366F1),
    navBar: Color(0xEE131A29),
    navBarBorder: Color(0x336366F1),
    shimmerBase: Color(0xFF1E293B),
    shimmerHighlight: Color(0xFF334155),
    noteCard1: Color(0xFF1E1B4B),
    noteCard2: Color(0xFF064E3B),
    noteCard3: Color(0xFF451A03),
    noteCard4: Color(0xFF3B0764),
    noteCard5: Color(0xFF1E3A5F),
  );

  static const AppColors amoled = AppColors(
    cardGlass: Color(0xCC0D0D0D),
    cardGlassBorder: Color(0x336366F1),
    navBar: Color(0xEE0A0A0A),
    navBarBorder: Color(0x336366F1),
    shimmerBase: Color(0xFF141414),
    shimmerHighlight: Color(0xFF222222),
    noteCard1: Color(0xFF12102E),
    noteCard2: Color(0xFF03261D),
    noteCard3: Color(0xFF2B1002),
    noteCard4: Color(0xFF24043D),
    noteCard5: Color(0xFF0F1E33),
  );

  @override
  AppColors copyWith({
    Color? cardGlass,
    Color? cardGlassBorder,
    Color? navBar,
    Color? navBarBorder,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? noteCard1,
    Color? noteCard2,
    Color? noteCard3,
    Color? noteCard4,
    Color? noteCard5,
  }) {
    return AppColors(
      cardGlass: cardGlass ?? this.cardGlass,
      cardGlassBorder: cardGlassBorder ?? this.cardGlassBorder,
      navBar: navBar ?? this.navBar,
      navBarBorder: navBarBorder ?? this.navBarBorder,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      noteCard1: noteCard1 ?? this.noteCard1,
      noteCard2: noteCard2 ?? this.noteCard2,
      noteCard3: noteCard3 ?? this.noteCard3,
      noteCard4: noteCard4 ?? this.noteCard4,
      noteCard5: noteCard5 ?? this.noteCard5,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      cardGlass: Color.lerp(cardGlass, other.cardGlass, t)!,
      cardGlassBorder: Color.lerp(cardGlassBorder, other.cardGlassBorder, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      navBarBorder: Color.lerp(navBarBorder, other.navBarBorder, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      noteCard1: Color.lerp(noteCard1, other.noteCard1, t)!,
      noteCard2: Color.lerp(noteCard2, other.noteCard2, t)!,
      noteCard3: Color.lerp(noteCard3, other.noteCard3, t)!,
      noteCard4: Color.lerp(noteCard4, other.noteCard4, t)!,
      noteCard5: Color.lerp(noteCard5, other.noteCard5, t)!,
    );
  }
}
