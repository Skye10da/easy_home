import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff485d92),
      surfaceTint: Color(0xff485d92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdae2ff),
      onPrimaryContainer: Color(0xff001847),
      secondary: Color(0xff585e71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdce2f9),
      onSecondaryContainer: Color(0xff151b2c),
      tertiary: Color(0xff735471),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffed7f9),
      onTertiaryContainer: Color(0xff2b122c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b21),
      onSurfaceVariant: Color(0xff45464f),
      outline: Color(0xff757780),
      outlineVariant: Color(0xffc5c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffb2c5ff),
      primaryFixed: Color(0xffdae2ff),
      onPrimaryFixed: Color(0xff001847),
      primaryFixedDim: Color(0xffb2c5ff),
      onPrimaryFixedVariant: Color(0xff304578),
      secondaryFixed: Color(0xffdce2f9),
      onSecondaryFixed: Color(0xff151b2c),
      secondaryFixedDim: Color(0xffc0c6dd),
      onSecondaryFixedVariant: Color(0xff404659),
      tertiaryFixed: Color(0xfffed7f9),
      onTertiaryFixed: Color(0xff2b122c),
      tertiaryFixedDim: Color(0xffe1bbdd),
      onTertiaryFixedVariant: Color(0xff5a3d59),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2c4174),
      surfaceTint: Color(0xff485d92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5f73aa),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3c4255),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6e7488),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff553955),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8a6a88),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b21),
      onSurfaceVariant: Color(0xff41424b),
      outline: Color(0xff5d5f67),
      outlineVariant: Color(0xff797a83),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffb2c5ff),
      primaryFixed: Color(0xff5f73aa),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff465a8f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6e7488),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff555b6f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8a6a88),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff70526f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff041f51),
      surfaceTint: Color(0xff485d92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2c4174),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1c2233),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3c4255),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff321933),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff553955),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff22242b),
      outline: Color(0xff41424b),
      outlineVariant: Color(0xff41424b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffe7ebff),
      primaryFixed: Color(0xff2c4174),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff132a5c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3c4255),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff262c3e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff553955),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3d243e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb2c5ff),
      surfaceTint: Color(0xffb2c5ff),
      onPrimary: Color(0xff172e60),
      primaryContainer: Color(0xff304578),
      onPrimaryContainer: Color(0xffdae2ff),
      secondary: Color(0xffc0c6dd),
      onSecondary: Color(0xff2a3042),
      secondaryContainer: Color(0xff404659),
      onSecondaryContainer: Color(0xffdce2f9),
      tertiary: Color(0xffe1bbdd),
      onTertiary: Color(0xff412742),
      tertiaryContainer: Color(0xff5a3d59),
      onTertiaryContainer: Color(0xfffed7f9),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc5c6d0),
      outline: Color(0xff8f9099),
      outlineVariant: Color(0xff45464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff485d92),
      primaryFixed: Color(0xffdae2ff),
      onPrimaryFixed: Color(0xff001847),
      primaryFixedDim: Color(0xffb2c5ff),
      onPrimaryFixedVariant: Color(0xff304578),
      secondaryFixed: Color(0xffdce2f9),
      onSecondaryFixed: Color(0xff151b2c),
      secondaryFixedDim: Color(0xffc0c6dd),
      onSecondaryFixedVariant: Color(0xff404659),
      tertiaryFixed: Color(0xfffed7f9),
      onTertiaryFixed: Color(0xff2b122c),
      tertiaryFixedDim: Color(0xffe1bbdd),
      onTertiaryFixedVariant: Color(0xff5a3d59),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33343a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb8caff),
      surfaceTint: Color(0xffb2c5ff),
      onPrimary: Color(0xff00143c),
      primaryContainer: Color(0xff7b8fc8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc4cae1),
      onSecondary: Color(0xff101626),
      secondaryContainer: Color(0xff8a90a5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe5bfe1),
      onTertiary: Color(0xff250d26),
      tertiaryContainer: Color(0xffa886a5),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xfffcfaff),
      onSurfaceVariant: Color(0xffc9cad4),
      outline: Color(0xffa1a2ac),
      outlineVariant: Color(0xff81838c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff31467a),
      primaryFixed: Color(0xffdae2ff),
      onPrimaryFixed: Color(0xff000f32),
      primaryFixedDim: Color(0xffb2c5ff),
      onPrimaryFixedVariant: Color(0xff1e3466),
      secondaryFixed: Color(0xffdce2f9),
      onSecondaryFixed: Color(0xff0a1121),
      secondaryFixedDim: Color(0xffc0c6dd),
      onSecondaryFixedVariant: Color(0xff303648),
      tertiaryFixed: Color(0xfffed7f9),
      onTertiaryFixed: Color(0xff1f0820),
      tertiaryFixedDim: Color(0xffe1bbdd),
      onTertiaryFixedVariant: Color(0xff482d48),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33343a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffcfaff),
      surfaceTint: Color(0xffb2c5ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffb8caff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcfaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc4cae1),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9fa),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe5bfe1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffcfaff),
      outline: Color(0xffc9cad4),
      outlineVariant: Color(0xffc9cad4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff0f275a),
      primaryFixed: Color(0xffe0e6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb8caff),
      onPrimaryFixedVariant: Color(0xff00143c),
      secondaryFixed: Color(0xffe1e6fe),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc4cae1),
      onSecondaryFixedVariant: Color(0xff101626),
      tertiaryFixed: Color(0xffffddfa),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe5bfe1),
      onTertiaryFixedVariant: Color(0xff250d26),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33343a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
