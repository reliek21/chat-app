import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Variables
const Color orangeColor = Colors.orange;
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color greyColor = Colors.grey;
const Color redColor = Colors.red;

const double circularRadius = 12.0;

/// Supabase client
final SupabaseClient supabase = Supabase.instance.client;

/// Simple preloader inside a Center widget
const Widget preloader = Center(
  child: CircularProgressIndicator(
    color: orangeColor
  )
);

/// Simple sized box to space out form elements
const Widget formSpacer = SizedBox(width: 16.0, height: 16.0);

/// Some padding for all the forms to use
const EdgeInsets formPadding = EdgeInsets.symmetric(
  vertical: 20.0,
  horizontal: 16.0
);

/// Error message to display the user when unexpected error occurs.
const String unexpectedErrorMessage = 'Unexpected error occurred.';

/// Basic theme to change the look and feel of the app
final appTheme = ThemeData.light().copyWith(
  primaryColorDark: orangeColor,
  appBarTheme: const AppBarTheme(
    elevation: 1.0,
    backgroundColor: whiteColor,
    iconTheme: IconThemeData(color: blackColor),
    titleTextStyle: TextStyle(
      color: blackColor,
      fontSize: 18.0,
    ),
  ),
  primaryColor: orangeColor,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: orangeColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: whiteColor,
      backgroundColor: orangeColor,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(
      color: orangeColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(circularRadius),
      borderSide: const BorderSide(
        color: greyColor,
        width: 2.0,
      ),
    ),
    focusColor: orangeColor,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(circularRadius),
      borderSide: const BorderSide(
        color: orangeColor,
        width: 2.0,
      ),
    ),
  ),
);

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = whiteColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: redColor);
  }
}
