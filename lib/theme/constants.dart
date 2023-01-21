import 'package:flutter/material.dart';

/// *
/// This file contains constants describing the primary colours and text
/// styles used in the project

// Colours

// Background colours
const backgroundBlack = Color.fromRGBO(0, 0, 0, 1.0);
const backgroundDarkGrey = Color.fromRGBO(31, 32, 34, 1.0);
const backgroundLightGrey = Color.fromRGBO(203, 196, 205, 1.0);
const backgroundWhite = Color.fromRGBO(255, 255, 255, 1.0);

// Accent colours
const accentGreen = Color.fromRGBO(92, 220, 73, 1.0);
const accentCyan = Color.fromRGBO(73, 220, 211, 1.0);
const accentPurple = Color.fromRGBO(184, 25, 255, 1.0);
const accentOrange = Color.fromRGBO(236, 177, 88, 1.0);
const accentLightGrey = Color.fromRGBO(203, 196, 205, 1.0);
const accentRed = Color.fromRGBO(255, 0, 0, 1.0);
const accentBlue = Color.fromRGBO(26, 188, 255, 1.0);
const accentDarkGrey = Color.fromRGBO(61, 62, 65, 1.0);

// Text colours
const textWhite = Color.fromRGBO(255, 255, 255, 1.0);
const textGrey = Color.fromRGBO(183, 179, 179, 1.0);
const textBlack = Color.fromRGBO(0, 0, 0, 1.0);

/// Converts a string to the appropriate colour from the constants defined in
/// this file
Color strToColor(String? str) {
  switch (str) {
    case "backgroundBlack":
      return backgroundBlack;
    case "backgroundDarkGrey":
      return backgroundDarkGrey;
    case "accentGreen":
      return accentGreen;
    case "accentCyan":
      return accentCyan;
    case "accentPurple":
      return accentPurple;
    case "accentOrange":
      return accentOrange;
    case "accentLightGrey":
      return accentLightGrey;
    case "accentRed":
      return accentRed;
    case "accentBlue":
      return accentBlue;
    case "accentDarkGrey":
      return accentDarkGrey;
    case "textWhite":
      return textWhite;
    case "textGrey":
      return textGrey;
    case "textBlack":
      return textBlack;
    default:
      throw Exception("Unknown colour: $str");
  }
}

// Text theme

const TextTheme textThemeDefault = TextTheme(
  displayLarge: TextStyle(
     color: textWhite, fontSize: 50
  ),
  displayMedium: TextStyle(
       color: textWhite, fontSize: 36
  ),
  displaySmall: TextStyle(
       color: textWhite, fontSize: 32
  ),
  headlineLarge: TextStyle(
       color: textWhite, fontSize: 50
  ),
  headlineMedium: TextStyle(
       color: textWhite, fontSize: 36
  ),
  headlineSmall: TextStyle(
       color: textWhite, fontSize: 32
  ),
  titleLarge: TextStyle(
       color: textWhite, fontSize: 32
  ),
  titleMedium: TextStyle(
       color: textWhite, fontSize: 25
  ),
  titleSmall: TextStyle(
       color: textWhite, fontSize: 20
  ),
  labelLarge: TextStyle(
       color: textWhite, fontSize: 16
  ),
  labelMedium: TextStyle(
       color: textWhite, fontSize: 14
  ),
  labelSmall: TextStyle(
       color: textWhite, fontSize: 10
  ),
  bodyLarge: TextStyle(
       color: textWhite, fontSize: 25, height: 1.5
  ),
  bodyMedium: TextStyle(
       color: textWhite, fontSize: 20, height: 1.5
  ),
  bodySmall: TextStyle(
       color: textWhite, fontSize: 15, height: 1.5
  )
);