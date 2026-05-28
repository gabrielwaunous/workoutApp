import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/core/theme/app_theme.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppTheme', () {
    test('hiit token is electric lime', () {
      expect(AppTheme.hiit, const Color(0xFFB8FF45));
    });

    test('rest token is warm orange', () {
      expect(AppTheme.rest, const Color(0xFFFF9A52));
    });

    test('fuerza token is blue', () {
      expect(AppTheme.fuerza, const Color(0xFF6BA8FF));
    });

    test('bg token is near-black', () {
      expect(AppTheme.bg, const Color(0xFF0B0C0E));
    });

    testWidgets('dark() returns ThemeData with correct scaffold background',
        (tester) async {
      final theme = AppTheme.dark();
      expect(theme.scaffoldBackgroundColor, AppTheme.bg);
    });

    testWidgets('dark() primary color is hiit lime', (tester) async {
      final theme = AppTheme.dark();
      expect(theme.colorScheme.primary, AppTheme.hiit);
    });

    testWidgets('dark() card color is bgCard', (tester) async {
      final theme = AppTheme.dark();
      expect(theme.cardTheme.color, AppTheme.bgCard);
    });
  });
}
