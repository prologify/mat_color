import 'package:flutter/material.dart';

String colorToHex(Color color) {
  return '#${color.red.toRadixString(16)}${color.green.toRadixString(16)}${color.blue.toRadixString(16)}';
}

Color hexToColor(String color) {
  color = color.replaceFirst('#', '');

  return Color.fromARGB(
    255,
    int.parse(color.substring(0, 2), radix: 16),
    int.parse(color.substring(2, 4), radix: 16),
    int.parse(color.substring(4), radix: 16),
  );
}
