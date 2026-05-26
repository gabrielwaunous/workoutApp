import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Surfaces
  static const Color bg = Color(0xFF0B0C0E);
  static const Color bgElev = Color(0xFF14161B);
  static const Color bgCard = Color(0xFF181B22);
  static const Color bgCard2 = Color(0xFF1F232C);
  static const Color bgChip = Color(0xFF252934);
  static const Color line = Color(0x12FFFFFF);
  static const Color lineStrong = Color(0x24FFFFFF);

  // Text
  static const Color text = Color(0xFFF1F2F5);
  static const Color textMid = Color(0xFF9DA0AA);
  static const Color textDim = Color(0xFF5E626E);
  static const Color textFaint = Color(0xFF3A3D46);

  // Semantic accents
  static const Color hiit = Color(0xFFB8FF45);
  static const Color hiitSoft = Color(0x20B8FF45);
  static const Color fuerza = Color(0xFF6BA8FF);
  static const Color fuerzaSoft = Color(0x226BA8FF);
  static const Color rest = Color(0xFFFF9A52);
  static const Color restSoft = Color(0x22FF9A52);
  static const Color danger = Color(0xFFFF5A5A);
  static const Color ok = Color(0xFF5BE39A);

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: hiit,
        onPrimary: bg,
        secondary: fuerza,
        surface: bgCard,
        onSurface: text,
        surfaceContainerHighest: bgCard2,
        outline: line,
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: line),
        ),
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
        bodyColor: text,
        displayColor: text,
      ),
      dividerColor: line,
      dividerTheme: const DividerThemeData(color: line, space: 1, thickness: 1),
    );
  }
}
