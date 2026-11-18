import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSchemes {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 80, 97, 164),
    onPrimary: Color.fromRGBO(255, 255, 255, 1),
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFEF7FF),
    onSurface: Color(0xFF1D1B20),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 215, 231, 233),
    onPrimary: Color(0xFF381E72),
    secondary: Color.fromARGB(255, 194, 214, 220),
    onSecondary: Color(0xFF332D41),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    surface: Color(0xFF141218),
    onSurface: Color(0xFFE6E1E5),
  );
}

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppSchemes.lightColorScheme,
      scaffoldBackgroundColor: const Color.fromARGB(236, 226, 244, 220),
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      cardTheme: CardThemeData(color: Colors.white),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: Colors.white,
      cardColor: const Color.fromARGB(255, 230, 206, 206),
      colorScheme: AppSchemes.darkColorScheme,
      scaffoldBackgroundColor: const Color.fromARGB(255, 29, 29, 30),
      appBarTheme: const AppBarTheme(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(color: const Color.fromARGB(255, 46, 46, 46)),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          // Aplica una transición de zoom predeterminada de Material 3 para todas las plataformas
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
