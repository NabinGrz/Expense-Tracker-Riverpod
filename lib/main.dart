import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/dashboard/dashboard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final themeMode = settingsAsync.value?.themeMode ?? ThemeMode.system;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker App',
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
        fontFamily: GoogleFonts.outfit().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          brightness: Brightness.dark,
          primary: AppColor.darkPrimary,
          surface: AppColor.darkSurfaceCard,
          onSurface: AppColor.textLight,
        ).copyWith(secondary: AppColor.darkPrimary),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        fontFamily: GoogleFonts.outfit().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.darkSurfaceCard,
          foregroundColor: AppColor.textLight,
        ),
        scaffoldBackgroundColor: AppColor.darkBackground,
        cardColor: AppColor.darkSurfaceCard,
        useMaterial3: false,
      ),
      home: const Dashboard(),
    );
  }
}
