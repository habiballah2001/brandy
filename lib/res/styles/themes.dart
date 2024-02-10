import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.deepPurpleAccent,
    brightness: Brightness.dark,
    cardColor: DarkColors.cardColor,
    scaffoldBackgroundColor: Colors.grey[750],
    iconTheme: const IconThemeData(color: Colors.white),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
      overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.shade100),
    )),
    appBarTheme: const AppBarTheme(
      titleSpacing: 20.0,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: DarkColors.textColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: DarkColors.textColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.red.shade800,
      unselectedItemColor: Colors.grey.shade100,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey[900],
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        color: DarkColors.textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: DarkColors.textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: DarkColors.textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: DarkColors.textColor,
        height: 1.8,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: DarkColors.textColor,
        height: 1.8,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: DarkColors.textColor,
        height: 1.8,
      ),
    ),
    //fontFamily: '',
  );
  static ThemeData lightTheme = ThemeData(
    primaryColor: LightColors.primaryColor,
    cardColor: LightColors.cardColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.bgColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: LightColors.bgColor,
      iconTheme: IconThemeData(
        color: Colors.black54,
        size: 25,
      ),
      titleSpacing: 20.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: LightColors.textColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    tabBarTheme: const TabBarTheme(labelColor: LightColors.textColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: secColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.grey,
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.black54),
      overlayColor: MaterialStateProperty.all(secColor),
    )),
    //primarySwatch: MaterialColor.,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        color: LightColors.textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: LightColors.textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: LightColors.textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: LightColors.textColor,
        height: 1.8,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: LightColors.textColor,
        height: 1.8,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: LightColors.textColor,
        height: 1.8,
      ),
    ),
    //fontFamily: 'Jannah',
  );
}
