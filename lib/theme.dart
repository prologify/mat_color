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
  final $lightContrast = contrast($color, Color(0xFFffffff));
  final $darkContrast = contrast($color, Color(0xFF000000));

  if ($lightContrast > $darkContrast) {
    return Color(0xFFffffff);
  } else {
    return Color(0xFF262626);
  }
}

class ThemeColor extends MaterialColor {
  int primaryIndex;

  ThemeColor(this.primaryIndex, Map<int, Color> swatch)
      : super(swatch[primaryIndex].value, swatch);

  Color get primaryColor {
    return this[primaryIndex];
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
      ),
      '${$name}Contrast': ThemeColor(
        $colorKeys[defaultIndex],
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
