import 'package:flutter/material.dart';
import 'dart:math' as math;

import './constants.dart';
import 'palette.dart';

num luminance(Color $color) {
  final $red = $linearChannelValues[$color.red.floor()];
  final $green = $linearChannelValues[$color.green.floor()];
  final $blue = $linearChannelValues[$color.blue.floor()];

  return .2126 * $red + .7152 * $green + .0722 * $blue;
}

num contrast(Color $back, Color $front) {
  final $backLum = luminance($back) + .05;
  final $foreLum = luminance($front) + .05;

  return math.max($backLum, $foreLum) / math.min($backLum, $foreLum);
}

Color chooseContrastColor(Color $color) {
  final $lightContrast = contrast($color, Colors.white);
  final $darkContrast = contrast($color, Colors.black);

  if ($lightContrast > $darkContrast) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

class ThemeColor extends MaterialColor {
  int primaryIndex;
  Map<int, Color> contrasts;

  ThemeColor(this.primaryIndex, Map<int, Color> swatch, this.contrasts)
      : super(swatch[primaryIndex].value, swatch);

  Color get primaryColor {
    return this[primaryIndex];
  }

  get contrast50 {
    return contrasts[50];
  }

  get contrast100 {
    return contrasts[100];
  }

  get contrast200 {
    return contrasts[200];
  }

  get contrast300 {
    return contrasts[300];
  }

  get contrast400 {
    return contrasts[400];
  }

  get contrast500 {
    return contrasts[500];
  }

  get contrast600 {
    return contrasts[600];
  }

  get contrast700 {
    return contrasts[700];
  }

  get contrast800 {
    return contrasts[800];
  }

  get contrast900 {
    return contrasts[900];
  }
}

Map<String, ThemeColor> theme(Map<String, Color> $themeColors) {
  var $result = <String, ThemeColor>{};

  for (MapEntry<String, Color> value in $themeColors.entries.toList()) {
    final $name = value.key;
    final $baseColor = value.value;
    final p = palette($baseColor);

    final List<Color> colors = p['colors'];
    final contrastColors = colors.map(chooseContrastColor).toList();
    final defaultIndex = p['defaultIndex'];

    $result = {
      ...$result,
      $name: ThemeColor(
        $colorKeys[defaultIndex],
        {
          50: colors[0],
          100: colors[1],
          200: colors[2],
          300: colors[3],
          400: colors[4],
          500: colors[5],
          600: colors[6],
          700: colors[7],
          800: colors[8],
          900: colors[9]
        },
        {
          50: contrastColors[0],
          100: contrastColors[1],
          200: contrastColors[2],
          300: contrastColors[3],
          400: contrastColors[4],
          500: contrastColors[5],
          600: contrastColors[6],
          700: contrastColors[7],
          800: contrastColors[8],
          900: contrastColors[9]
        },
      ),
    };
  }

  return $result;
}
