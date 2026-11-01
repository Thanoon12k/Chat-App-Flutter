import 'package:flutter/material.dart';

/// The app's original look: soft pink background with red accents.
const oldPink = Color(0xFFE4D3D3);
const oldRed = Color(0xFFF44336);

/// Pastel bubble colors from the original chat screen, picked per sender.
const bubbleColors = [
  Color(0xFFE9E8BA), // yellow
  Color(0xFFBAE9DD), // teal
  Color(0xFFE1BAE9), // purple
  Color(0xFFBEE9BA), // green
];

/// My own messages: a light red that fits the pink theme.
const myBubbleColor = Color(0xFFFFCDD2);

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: oldRed,
    brightness: Brightness.light,
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
  ).copyWith(
    primary: oldRed,
    onPrimary: Colors.white,
    surface: oldPink,
    surfaceContainerLow: const Color(0xFFF1E6E6),
    surfaceContainer: const Color(0xFFF1E6E6),
    surfaceContainerHigh: const Color(0xFFF6EEEE),
    surfaceContainerHighest: Colors.white,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Cairo',
  );
  return base.copyWith(
    scaffoldBackgroundColor: oldPink,
    appBarTheme: const AppBarTheme(
      backgroundColor: oldPink,
      foregroundColor: Colors.black87,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: oldRed,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
            fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Color(0xFFF6EEEE)),
    dialogTheme: const DialogThemeData(backgroundColor: Color(0xFFF6EEEE)),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
