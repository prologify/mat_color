import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'constants.dart';

class LabColor {
  num l;
  num b;
  num a;

  LabColor(this.l, this.a, this.b);

  LabColor.fromColor(Color color) {
    final $xyz = _rgb2xyz(color);

    this.l = 116 * $xyz['y'] - 16;
    this.l = this.l < 0 ? 0 : this.l;
    this.a = 500 * ($xyz['x'] - $xyz['y']);
    this.b = 200 * ($xyz['y'] - $xyz['z']);
  }

  HslColor toHsl() {
    return HslColor(
      ((180 * math.atan2(this.b, this.a) / math.pi + 360) % 360),
      math.sqrt(math.pow(this.a, 2) + math.pow(this.b, 2)),
      this.l,
    );
  }

  _rgb2xyz(Color color) {
    final $r = _rgbXyz(color.red);
    final $g = _rgbXyz(color.green);
    final $b = _rgbXyz(color.blue);
    final $x = _xyzLab(
        (0.4124564 * $r + 0.3575761 * $g + 0.1804375 * $b) / LabConstantsXn);
    final $y = _xyzLab(
        (0.2126729 * $r + 0.7151522 * $g + 0.0721750 * $b) / LabConstantsYn);
    final $z = _xyzLab(
        (0.0193339 * $r + 0.1191920 * $g + 0.9503041 * $b) / LabConstantsZn);
    return {'x': $x, 'y': $y, 'z': $z};
  }

  _rgbXyz(num r) {
    r = r / 255;

    if (r <= 0.04045) {
      return r / 12.92;
    } else {
      return math.pow((r + 0.055) / 1.055, 2.4);
    }
  }

  _xyzLab($t) {
    if ($t > LabConstantsT3) {
      return math.pow($t, 1 / 3);
    }

    return $t / LabConstantsT2 + LabConstantsT0;
  }
}

class HslColor {
  num saturation;

  num hue;

  num lightness;

  HslColor(this.hue, this.saturation, this.lightness);
}
