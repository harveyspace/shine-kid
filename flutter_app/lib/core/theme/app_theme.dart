import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFff9500);
  static const Color secondaryColor = Color(0xFF007AFF);
  static const Color successColor = Color(0xFF34C759);
  static const Color warningColor = Color(0xFFFFCC00);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color infoColor = Color(0xFF5AC8FA);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF86868B);
  static const Color textTertiary = Color(0xFFC7C7CC);

  static const Color border = Color(0xFFE5E5EA);
  static const Color divider = Color(0xFFF2F2F7);

  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusSmall = 8.0;

  static const double elevation = 4.0;
  static const double elevationLarge = 8.0;

  static ThemeData get lightTheme => ThemeData(
        primaryColor: primaryColor,
        primarySwatch: createMaterialColor(primaryColor),
        scaffoldBackgroundColor: background,
        cardColor: card,
        dividerColor: divider,
        textTheme: _textTheme,
        iconTheme: const IconThemeData(color: textSecondary),
        buttonTheme: _buttonTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        appBarTheme: _appBarTheme,
        bottomNavigationBarTheme: _bottomNavigationBarTheme,
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        primaryColor: primaryColor,
        primarySwatch: createMaterialColor(primaryColor),
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        cardColor: const Color(0xFF2C2C2E),
        dividerColor: const Color(0xFF3A3A3C),
        textTheme: _darkTextTheme,
        iconTheme: const IconThemeData(color: textSecondary),
        buttonTheme: _buttonTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _darkInputDecorationTheme,
        appBarTheme: _darkAppBarTheme,
        bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
        useMaterial3: true,
      );

  static const TextTheme _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textTertiary,
    ),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textTertiary,
    ),
  );

  static const ButtonThemeData _buttonTheme = ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  static InputDecorationTheme get _inputDecorationTheme =>
      InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: border),
        ),
        hintStyle: const TextStyle(color: textTertiary),
        labelStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  static InputDecorationTheme get _darkInputDecorationTheme =>
      InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: border),
        ),
        hintStyle: const TextStyle(color: textTertiary),
        labelStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        fillColor: const Color(0xFF2C2C2E),
        filled: true,
      );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: surface,
    foregroundColor: textPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: Color(0xFF1C1C1E),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        elevation: elevation,
      );

  static BottomNavigationBarThemeData get _darkBottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        elevation: elevation,
      );

  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
