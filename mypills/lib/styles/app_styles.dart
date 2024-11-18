import 'package:flutter/material.dart';

//=======================================================================

class AppStyles {
  static const _black = Colors.black45;
  static const _white = Colors.white;
  static const _mantis = Color(0xFF81c14b);
  static const _darkOchre = Color(0xFF754306);
  static const _ochre = Color(0xFFc36f09);
  static final fonts = (
    fontFamilyName: 'Montserrat',
    display /*bigTitle*/ : ({
      Color color = _black,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.normal,
      TextDecoration decoration = TextDecoration.none,
    }) =>
        TextStyle(
          inherit: false,
          fontSize: 40,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration,
          color: color,
        ),
    headline /*middleTitle*/ : ({
      Color color = _black,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.bold,
      TextDecoration decoration = TextDecoration.none,
    }) =>
        TextStyle(
          inherit: false,
          fontSize: 24,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration,
          color: color,
        ),
    labelLarge /*distance*/ : ({
      Color color = _black,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.normal,
      TextDecoration decoration = TextDecoration.none,
    }) =>
        TextStyle(
          inherit: false,
          fontSize: 24,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration,
          color: color,
        ),
    labelInverseLarge /*distance*/ : ({
      Color color = _mantis,
      Color background = _ochre,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.normal,
      TextDecoration decoration = TextDecoration.none,
    }) =>
        TextStyle(
          inherit: false,
          fontSize: 24,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration,
          color: color,
          backgroundColor: background,
        ),
    labelSmall /*activityType*/ : ({
      Color color = _black,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.normal,
      TextDecoration decoration = TextDecoration.none,
    }) =>
        TextStyle(
          inherit: false,
          fontSize: 18,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration,
          color: color,
        ),
    body: ({
      Color color = _black,
      FontStyle fontStyle = FontStyle.normal,
      FontWeight fontWeight = FontWeight.normal,
      TextDecoration decoration = TextDecoration.none,
    }) =>
        TextStyle(
          inherit: false,
          fontSize: 14,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          decoration: decoration,
          color: color,
        ),
  );

/*
https://coolors.co/c36f09-81c14b-2e933c-297045-204e4a
{
//'buff': { DEFAULT: '#ecba82', 100: '#40270a', 200: '#804d13', 300: '#c0741d', 400: '#e39843', 500: '#ecba82', 600: '#f0c99c', 700: '#f4d6b4', 800: '#f8e4cd', 900: '#fbf1e6' },
'ochre': { DEFAULT: '#c36f09', 100: '#271602', 200: '#4e2d04', 300: '#754306', 400: '#9c5907', 500: '#c36f09', 600: '#f49015', 700: '#f7ac50', 800: '#f9c78a', 900: '#fce3c5' },
'mantis': { DEFAULT: '#81c14b', 100: '#1a280e', 200: '#33511c', 300: '#4d7929', 400: '#67a137', 500: '#81c14b', 600: '#9ace70', 700: '#b4da94', 800: '#cde7b8', 900: '#e6f3db' },
'forest_green': { DEFAULT: '#2e933c', 100: '#091d0c', 200: '#133b18', 300: '#1c5824', 400: '#257630', 500: '#2e933c', 600: '#3fc250', 700: '#6fd17c', 800: '#9fe1a8', 900: '#cff0d3' },
'dark_spring_green': { DEFAULT: '#297045', 100: '#08160e', 200: '#112d1c', 300: '#19432a', 400: '#215938', 500: '#297045', 600: '#3da466', 700: '#63c58a', 800: '#97d8b1', 900: '#cbecd8' },
'dark_slate_gray': { DEFAULT: '#204e4a', 100: '#07100f', 200: '#0d201e', 300: '#14302d', 400: '#1a403d', 500: '#204e4a', 600: '#388881', 700: '#56bab1', 800: '#8ed1cb', 900: '#c7e8e5' }
}
*/

  static const colors = (
    black: _black,
    white: _white,
    // 'ochre': { DEFAULT: '#c36f09', 100: '#271602', 200: '#4e2d04', 300: '#754306', 400: '#9c5907', 500: '#c36f09', 600: '#f49015', 700: '#f7ac50', 800: '#f9c78a', 900: '#fce3c5' },
    ochre: MaterialColor(0xFFc36f09, <int, Color>{
      100: Color(0xFF271602),
      200: Color(0xFF4e2d04),
      300: Color(0xFF754306),
      400: Color(0xFF9c5907),
      500: Color(0xFFc36f09),
      600: Color(0xFFf49015),
      700: Color(0xFFf7ac50),
      800: Color(0xFFf9c78a),
      900: Color(0xFFfce3c5),
    }),
    // 'mantis': { DEFAULT: '#81c14b', 100: '#1a280e', 200: '#33511c', 300: '#4d7929', 400: '#67a137', 500: '#81c14b', 600: '#9ace70', 700: '#b4da94', 800: '#cde7b8', 900: '#e6f3db' },
    mantis: MaterialColor(0xFF81c14b, <int, Color>{
      100: Color(0xFF1a280e),
      200: Color(0xFF33511c),
      300: Color(0xFF4d7929),
      400: Color(0xFF67a137),
      500: Color(0xFF81c14b),
      600: Color(0xFF9ace70),
      700: Color(0xFFb4da94),
      800: Color(0xFFcde7b8),
      900: Color(0xFFe6f3db),
    }),
    // 'forest_green': { DEFAULT: '#2e933c', 100: '#091d0c', 200: '#133b18', 300: '#1c5824', 400: '#257630', 500: '#2e933c', 600: '#3fc250', 700: '#6fd17c', 800: '#9fe1a8', 900: '#cff0d3' },
    forestGreen: MaterialColor(0xFF2e933c, <int, Color>{
      100: Color(0xFF091d0c),
      200: Color(0xFF133b18),
      300: Color(0xFF1c5824),
      400: Color(0xFF257630),
      500: Color(0xFF2e933c),
      600: Color(0xFF3fc250),
      700: Color(0xFF6fd17c),
      800: Color(0xFF9fe1a8),
      900: Color(0xFFcff0d3),
    }),
    // 'dark_spring_green': { DEFAULT: '#297045', 100: '#08160e', 200: '#112d1c', 300: '#19432a', 400: '#215938', 500: '#297045', 600: '#3da466', 700: '#63c58a', 800: '#97d8b1', 900: '#cbecd8' },
    darkSpringGreen: MaterialColor(0xFF297045, <int, Color>{
      100: Color(0xFF08160e),
      200: Color(0xFF112d1c),
      300: Color(0xFF19432a),
      400: Color(0xFF215938),
      500: Color(0xFF297045),
      600: Color(0xFF3da466),
      700: Color(0xFF63c58a),
      800: Color(0xFF97d8b1),
      900: Color(0xFFcbecd8),
    }),
    // 'dark_slate_gray': { DEFAULT: '#204e4a', 100: '#07100f', 200: '#0d201e', 300: '#14302d', 400: '#1a403d', 500: '#204e4a', 600: '#388881', 700: '#56bab1', 800: '#8ed1cb', 900: '#c7e8e5' }
    darkSlateGray: MaterialColor(0xFF204e4a, <int, Color>{
      100: Color(0xFF07100f),
      200: Color(0xFF0d201e),
      300: Color(0xFF14302d),
      400: Color(0xFF1a403d),
      500: Color(0xFF204e4a),
      600: Color(0xFF388881),
      700: Color(0xFF56bab1),
      800: Color(0xFF8ed1cb),
      900: Color(0xFFc7e8e5),
    }),
  );

  // Invert color index for Brightness.dark mode
  // Caution: do not use when index is not invertible
  // pre: isIndexColorInvertible(i)
  static int colorIndex(Brightness mode, int i) {
    assert(isIndexColorInvertible(i));
    return mode == Brightness.light ? i : invertColorIndex(i);
  }

  // Used to compute colorIndex from Brightness Mode
  // Can also be used to obtain a valid contrast tone
  // Caution: index can't be out of range
  // pre: i >=0 && i <= 1000
  static int invertColorIndex(int i) {
    assert(i >= 0 && i <= 1000);
    return 1000 - i;
  }

  // It's only a valid tone when invertColorIndex will make an
  // enough contrast tone with actual tone; use:
  // light values between 0..300, but allows not normalized values up to 349
  // dark values bettween 700..1000, but allows not normalized values from 650
  // also note that zero and 1000 are not normalized values.
  static bool isIndexColorInvertible(int i) {
    return i >= 0 && i < 350 || i >= 650 && i <= 1000;
  }

  // Allow normalization of a computed color index
  // negative values are not allowed
  // post: return in {100, 200, 300, 400, 500, 600, 700, 800, 900}
  static int normalizeIndexColor(int i) {
    return switch (i) {
      < 0 => throw RangeError('Index out of range: $i'),
      < 150 => 100,
      >= 850 => 900,
      _ => ((100 + 50) ~/ 100) * 100
    };
  }
}
