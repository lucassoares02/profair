import 'package:flutter/material.dart';

// ─── Paleta de Cores ─────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Cores principais
  static const primary = Color(0xFFB16CFF);
  static const secondary = Color(0xFF6E41FF);

  // Variações da primary
  static const primaryLight = Color(0xFFD4A8FF);
  static const primaryDark = Color(0xFF8A3FD6);

  // Variações da secondary
  static const secondaryLight = Color(0xFF9E7FFF);
  static const secondaryDark = Color(0xFF4A1FD6);

  // ── Light Theme ──────────────────────────────────────────────────────────

  static const lightBackground = Color(0xFFF9F7FC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF1ECF9);
  static const lightSurfaceContainer = Color(0xFFF5F1FA);

  static const lightOnBackground = Color(0xFF1A1225);
  static const lightOnSurface = Color(0xFF1A1225);
  static const lightOnSurfaceVariant = Color(0xFF4A3D5C);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightOnSecondary = Color(0xFFFFFFFF);

  static const lightOutline = Color(0xFFD6CCE6);
  static const lightOutlineVariant = Color(0xFFE8E0F2);
  static const lightDivider = Color(0xFFEDE8F5);

  static const lightError = Color(0xFFDC3545);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFCE4E8);

  static const lightSuccess = Color(0xFF22C55E);
  static const lightWarning = Color(0xFFFBBF24);
  static const lightInfo = Color(0xFF3B82F6);

  // ── Dark Theme ───────────────────────────────────────────────────────────

  static const darkBackground = Color(0xFF0F0A1A);
  static const darkSurface = Color(0xFF1A1228);
  static const darkSurfaceVariant = Color(0xFF241A35);
  static const darkSurfaceContainer = Color(0xFF1F1630);

  static const darkOnBackground = Color(0xFFF1ECF9);
  static const darkOnSurface = Color(0xFFEDE8F5);
  static const darkOnSurfaceVariant = Color(0xFFB0A3C4);
  static const darkOnPrimary = Color(0xFFFFFFFF);
  static const darkOnSecondary = Color(0xFFFFFFFF);

  static const darkOutline = Color(0xFF3D2E54);
  static const darkOutlineVariant = Color(0xFF2E2242);
  static const darkDivider = Color(0xFF2E2242);

  static const darkError = Color(0xFFFF6B7A);
  static const darkOnError = Color(0xFF1A1225);
  static const darkErrorContainer = Color(0xFF3D1520);

  static const darkSuccess = Color(0xFF4ADE80);
  static const darkWarning = Color(0xFFFCD34D);
  static const darkInfo = Color(0xFF60A5FA);
}

// ─── Tema Light ──────────────────────────────────────────────────────────────

final ThemeData appLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: 'Inter',
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.lightOnSecondary,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.secondaryDark,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    surfaceContainerHighest: AppColors.lightSurfaceVariant,
    error: AppColors.lightError,
    onError: AppColors.lightOnError,
    errorContainer: AppColors.lightErrorContainer,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
    shadow: Color(0x1A6E41FF),
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  dividerColor: AppColors.lightDivider,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0.5,
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.lightOnSurface,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.lightOnSurface,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: AppColors.lightSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.lightOutlineVariant, width: 1),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.lightOnPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: AppColors.primary, width: 1.5),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.lightOnSecondary,
    elevation: 4,
    shape: CircleBorder(),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightSurfaceContainer,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightOutlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightError),
    ),
    hintStyle: const TextStyle(color: AppColors.lightOnSurfaceVariant),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.lightSurfaceVariant,
    selectedColor: AppColors.primaryLight,
    labelStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide.none,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightSurface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.lightOnSurfaceVariant,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.lightSurface,
    indicatorColor: AppColors.primaryLight.withOpacity(0.3),
    surfaceTintColor: Colors.transparent,
    labelTextStyle: WidgetStatePropertyAll(
      const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.lightOnSurface,
    contentTextStyle: const TextStyle(
      fontFamily: 'Inter',
      color: AppColors.lightSurface,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.lightSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.lightSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.lightSurfaceVariant,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.primary;
      return AppColors.lightOnSurfaceVariant;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryLight.withOpacity(0.5);
      }
      return AppColors.lightOutlineVariant;
    }),
  ),
);

// ─── Tema Dark ───────────────────────────────────────────────────────────────

final ThemeData appDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: 'Inter',
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.secondaryDark,
    onSecondaryContainer: AppColors.secondaryLight,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    shadow: Color(0x40000000),
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  dividerColor: AppColors.darkDivider,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0.5,
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.darkOnSurface,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.darkOnSurface,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: AppColors.darkSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.darkOutlineVariant, width: 1),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.darkOnPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondaryLight,
    foregroundColor: AppColors.darkOnSecondary,
    elevation: 4,
    shape: CircleBorder(),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurfaceContainer,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkOutlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.darkError),
    ),
    hintStyle: const TextStyle(color: AppColors.darkOnSurfaceVariant),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.darkSurfaceVariant,
    selectedColor: AppColors.primaryDark,
    labelStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide.none,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: AppColors.darkOnSurfaceVariant,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    indicatorColor: AppColors.primaryDark.withOpacity(0.3),
    surfaceTintColor: Colors.transparent,
    labelTextStyle: WidgetStatePropertyAll(
      const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.darkOnSurface,
    contentTextStyle: const TextStyle(
      fontFamily: 'Inter',
      color: AppColors.darkSurface,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: AppColors.darkSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.darkSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryLight,
    linearTrackColor: AppColors.darkSurfaceVariant,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColors.primaryLight;
      return AppColors.darkOnSurfaceVariant;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryDark.withOpacity(0.5);
      }
      return AppColors.darkOutlineVariant;
    }),
  ),
);
