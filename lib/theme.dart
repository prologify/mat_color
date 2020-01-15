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

theme(Map<String, Color> $themeColors) {
  var $result = {};

  for (MapEntry<String, Color> value in $themeColors.entries.toList()) {
    final $name = value.key;
    final $baseColor = value.value;
    final p = palette($baseColor);

    final colors = p['colors'];
    final defaultIndex = p['defaultIndex'];

    var $colorSet = {};
    var $contrast = {};

    for (var $i = 0; $i < $colorKeys.length; $i++) {
      final $key = $colorKeys[$i];
      final $value = colors[$i];
      $colorSet = {...$colorSet, $key: $value};
      $contrast = {...$contrast, $key: chooseContrastColor($value)};

      if ($i == defaultIndex) {
        final $darkIndex = $i + 1 > $colorKeys.length ? $i : $i + 1;
        final $defaultIndex = $darkIndex - 1;
        final $lightIndex = $darkIndex - 2;

        $colorSet = {
          ...$colorSet,
          'default': $colorKeys[$defaultIndex],
          'dark': $darkIndex > -1 && $darkIndex < $colorKeys.length
              ? $colorKeys[$darkIndex]
              : $colorKeys[$defaultIndex],
          'light': $lightIndex > -1 && $lightIndex < $colorKeys.length
              ? $colorKeys[$lightIndex]
              : $colorKeys[$defaultIndex]
        };
      }
    }

    $colorSet = {...$colorSet, 'contrast': $contrast};
    $result = {...$result, $name: $colorSet};
  }

  return $result;
}
