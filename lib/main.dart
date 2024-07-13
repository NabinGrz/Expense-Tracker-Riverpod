import 'dart:convert';

import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/expense/add_new_expense_dialog.dart/add_new_expense_dialog.dart';
import 'package:expense_tracker_flutter/features/home/screen/home_screen.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:expense_tracker_flutter/utils/expense_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';

import 'firebase_options.dart';
import 'shared/provider/sort_by_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        fontFamily: GoogleFonts.poppins().fontFamily,
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}
