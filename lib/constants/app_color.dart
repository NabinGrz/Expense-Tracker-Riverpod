import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static Color primary = const Color(0xff428a78);
  static Color test = const Color.fromARGB(255, 62, 166, 140);

  // Curated Preset Accent Colors
  static const List<Map<String, dynamic>> accentOptions = [
    {'name': 'Emerald', 'color': Color(0xff428a78)},
    {'name': 'Sapphire', 'color': Color(0xff2563EB)},
    {'name': 'Amethyst', 'color': Color(0xff7C3AED)},
    {'name': 'Ruby', 'color': Color(0xffE11D48)},
    {'name': 'Sunset', 'color': Color(0xffD97706)},
    {'name': 'Midnight', 'color': Color(0xff475569)},
  ];

  // Dark Mode Colors
  static Color darkPrimary = const Color(0xff80cbc4);
  static Color darkBackground = const Color(0xff121212);
  static Color darkSurface = const Color(0xff1e1e1e);
  static Color darkSurfaceCard = const Color(0xff2C2C2C);
  static Color textLight = const Color(0xFFFAFAFA);
}
