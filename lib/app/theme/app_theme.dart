import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF0E5AA7);
  static const Color govBrBlue = Color(0xFF003B7A);

  static ThemeData light({
    bool highContrast = false,
    bool colorBlindAssist = false,
  }) {
    final Color background = highContrast
        ? const Color(0xFFF2F4F7)
        : (colorBlindAssist ? const Color(0xFFF4F7FA) : const Color(0xFFF6F8FB));
    final Color surface = Colors.white;
    final Color textPrimary = highContrast
        ? const Color(0xFF0A0A0A)
        : (colorBlindAssist ? const Color(0xFF0F172A) : const Color(0xFF10243E));
    final Color textSecondary = highContrast
        ? const Color(0xFF202020)
        : (colorBlindAssist ? const Color(0xFF475569) : const Color(0xFF4D5E72));
    final Color outline = highContrast
        ? const Color(0xFF475467)
        : (colorBlindAssist ? const Color(0xFFCBD5E1) : const Color(0xFFE4EAF2));

    final Color primary = colorBlindAssist
        ? const Color(0xFF3F51B5)
        : (highContrast ? const Color(0xFF003B7A) : _seed);
    final Color success = colorBlindAssist
        ? const Color(0xFF00796B)
        : const Color(0xFF2E7D32);
    final Color warning = colorBlindAssist
        ? const Color(0xFF8E24AA)
        : const Color(0xFFB26A00);
    final Color indicator = highContrast
        ? const Color(0xFFD7E7FA)
        : (colorBlindAssist
            ? const Color(0xFFDCEAFE)
            : primary.withValues(alpha: 0.14));

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      secondary: success,
      tertiary: warning,
      surface: surface,
      error: highContrast ? const Color(0xFF8B0000) : const Color(0xFFB42318),
      onSurface: textPrimary,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      outline: outline,
      outlineVariant: outline,
      surfaceContainerHighest: colorBlindAssist
          ? const Color(0xFFE6EEF9)
          : const Color(0xFFEAF2FB),
      surfaceContainer: colorBlindAssist
          ? const Color(0xFFF1F5F9)
          : const Color(0xFFF4F7FB),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: indicator,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) {
            final bool selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? scheme.primary : textSecondary,
            );
          },
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return colorBlindAssist ? scheme.tertiary : scheme.secondary;
          }
          return null;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: colorBlindAssist ? scheme.tertiary : scheme.primary,
        thumbColor: colorBlindAssist ? scheme.tertiary : scheme.primary,
        overlayColor: (colorBlindAssist ? scheme.tertiary : scheme.primary)
            .withValues(alpha: 0.12),
        inactiveTrackColor: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: highContrast ? 0 : 1.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: highContrast ? const Color(0xFF1D2939) : outline,
            width: highContrast ? 1.4 : 1.1,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(
            color: highContrast ? const Color(0xFF344054) : scheme.outlineVariant,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 0.8,
        color: outline,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.45,
          color: textSecondary,
        ),
      ),
    );
  }

  static Color successColorOf(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  static Color warningColorOf(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;

  static Color infoColorOf(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color neutralColorOf(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.color ??
      const Color(0xFF6B7E90);
}
