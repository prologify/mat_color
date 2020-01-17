import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'colors.dart';
import 'constants.dart';

ab(num $a, num $b) {
  if (1e-4 > $a.abs() && 1e-4 > $b.abs()) {
    return 0;
  }

  final $aa = 180 * math.atan2($a, $b) / math.pi;
  return 0 <= $aa ? $aa : $aa + 360;
}

A(num $a, num $b, num $c) {
  return math.min(math.max($a, $b), $c);
}

zb(num $a) {
  final $b = 6 / 29;
  final $c = 3 * math.pow($b, 2);
  return $a > $b ? math.pow($a, 3) : $c * ($a - 4 / 29);
}

yb($a) {
  return .0031308 >= $a ? 12.92 * $a : 1.055 * math.pow($a, 1 / 2.4) - .055;
}

getPrebuiltPalette(LabColor $labColor) {
  var $colors = PrebuiltColors[0];
  var $index = -1;
  var $c = 1e10;

  for (int $i = 0; $i < PrebuiltColors.length; $i++) {
    final $prebuiltColor = PrebuiltColors[$i];

    for (var $j = 0; $j < $prebuiltColor.length; $j++) {
      final LabColor $currentColor = LabColor(
          $prebuiltColor[$j][0], $prebuiltColor[$j][1], $prebuiltColor[$j][2]);
      final $colorL = ($currentColor.l + $labColor.l) / 2;
      var $currentColorAB = math
          .sqrt(math.pow($currentColor.a, 2) + math.pow($currentColor.b, 2));
      var $labColorAB =
          math.sqrt(math.pow($labColor.a, 2) + math.pow($labColor.b, 2));
      var $ij = ($currentColorAB + $labColorAB) / 2;
      $ij = .5 *
          (1 -
              math.sqrt(
                  math.pow($ij, 7) / (math.pow($ij, 7) + math.pow(25, 7))));

      var $n = $currentColor.a * (1 + $ij);
      var $r = $labColor.a * (1 + $ij);
      var $N = math.sqrt(math.pow($n, 2) + math.pow($currentColor.b, 2));
      var $H = math.sqrt(math.pow($r, 2) + math.pow($labColor.b, 2));
      $ij = $H - $N;
      final $ja = ($N + $H) / 2;
      $n = ab($currentColor.b, $n);
      $r = ab($labColor.b, $r);

      $N = 2 *
          math.sqrt($N * $H >= 0 ? $N * $H : 0) *
          math.sin(((1e-4 > $currentColorAB.abs() || 1e-4 > $labColorAB.abs())
                  ? 0
                  : (180 >= ($r - $n).abs()
                      ? $r - $n
                      : ($r <= $n ? $r - $n + 360 : $r - $n - 360))) /
              2 *
              math.pi /
              180);
      $currentColorAB = (1e-4 > $currentColorAB.abs() ||
              1e-4 > $labColorAB.abs()
          ? 0
          : (180 >= ($r - $n).abs()
              ? ($n + $r) / 2
              : (360 > $n + $r ? ($n + $r + 360) / 2 : ($n + $r - 360) / 2)));
      $labColorAB = 1 + .045 * $ja;
      $H = 1 +
          .015 *
              $ja *
              (1 -
                  .17 * math.cos(($currentColorAB - 30) * math.pi / 180) +
                  .24 * math.cos(2 * $currentColorAB * math.pi / 180) +
                  .32 * math.cos((3 * $currentColorAB + 6) * math.pi / 180) -
                  .2 * math.cos((4 * $currentColorAB - 63) * math.pi / 180));
      final $temp1 = math.sqrt(math.pow(
              ($labColor.l - $currentColor.l) /
                  (1 +
                      .015 *
                          math.pow($colorL - 50, 2) /
                          math.sqrt((20 + math.pow($colorL - 50, 2) >= 0
                              ? 20 + math.pow($colorL - 50, 2)
                              : 0))),
              2) +
          math.pow($ij / ($labColorAB), 2) +
          math.pow($N / ($H), 2) +
          $ij /
              ($labColorAB) *
              math.sqrt(
                  (math.pow($ja, 7) / (math.pow($ja, 7) + math.pow(25, 7)) >= 0
                      ? math.pow($ja, 7) / (math.pow($ja, 7) + math.pow(25, 7))
                      : 0)) *
              math.sin(60 *
                  math.exp(-math.pow(($currentColorAB - 275) / 25, 2)) *
                  math.pi /
                  180) *
              -2 *
              ($N / ($H)));

      if ($temp1 < $c) {
        $c = $temp1;
        $colors = $prebuiltColor;
        $index = $j;
      }
    }
  }

  return {'colors': $colors, 'index': $index};
}

palette(Color $pColor) {
  var $lab = LabColor.fromColor($pColor);
  final $prebuiltPalette = getPrebuiltPalette($lab);

  final $colors = $prebuiltPalette['colors'];
  final $index = $prebuiltPalette['index'];

  final $primaryColor = $colors[$index];
  final $primaryHslColor =
      new LabColor($primaryColor[0], $primaryColor[1], $primaryColor[2])
          .toHsl();
  final HslColor $hslColor = $lab.toHsl();

  final $sixColor = $colors[5];
  final $k = 30 >
      LabColor($sixColor[0], $sixColor[1], $sixColor[2]).toHsl().saturation;
  final $lightness = $primaryHslColor.lightness - $hslColor.lightness;
  final $saturation = $primaryHslColor.saturation - $hslColor.saturation;
  final $hue = $primaryHslColor.hue - $hslColor.hue;
  final $cbIndex = Cb[$index];
  final $dbIndex = Db[$index];
  var $r = 100.0;

  final $newColors = <Color>[];

  for (var $colorIndex = 0; $colorIndex < $colors.length; $colorIndex++) {
    final $color = $colors[$colorIndex];
    if ($colorIndex == $index) {
      $r = math.max($hslColor.lightness - 1.7, 0);
      $newColors.add($pColor);
    } else {
      final HslColor $hsl1 = LabColor($color[0], $color[1], $color[2]).toHsl();
      var $d = $hsl1.lightness - Cb[$colorIndex] / $cbIndex * $lightness;
      $d = math.min<num>($d, $r);
      final HslColor $hsl2 = HslColor(
          ($hsl1.hue - $hue + 360) % 360,
          math.max(
              0,
              ($k
                  ? $hsl1.saturation - $saturation
                  : $hsl1.saturation -
                      $saturation *
                          math.min(Db[$colorIndex] / $dbIndex, 1.25))),
          A($d, 0, 100));
      $r = math.max($hsl2.lightness - 1.7, 0);
      var $b = $hsl2.hue * math.pi / 180;
      $lab = LabColor($hsl2.lightness, $hsl2.saturation * math.cos($b),
          $hsl2.saturation * math.sin($b));
      var $g = ($lab.l + 16) / 116;
      $b = .95047 * zb($g + $lab.a / 500);
      $d = zb($g);
      $g = 1.08883 * zb($g - $lab.b / 200);
      final $newColor = Color.fromARGB(
        255,
        (A(yb(3.2404542 * $b + -1.5371385 * $d + -.4985314 * $g), 0, 1) * 255)
            .floor(),
        (A(yb(-.969266 * $b + 1.8760108 * $d + .041556 * $g), 0, 1) * 255)
            .floor(),
        (A(yb(.0556434 * $b + -.2040259 * $d + 1.0572252 * $g), 0, 1) * 255)
            .floor(),
      );
      $newColors.add($newColor);
    }
  }

  return {'colors': $newColors, 'defaultIndex': $index};
}
