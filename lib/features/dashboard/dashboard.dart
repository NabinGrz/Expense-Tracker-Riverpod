import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/features/expense/screen/search_screen.dart';
import 'package:expense_tracker_flutter/features/savings/screen/savings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../expense/screen/home_screen.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  int get currentIndex => ref.watch(bottomNavBarProvider);

  Widget _getBody() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchExpenseScreen();
      case 2:
        return const SavingsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        currentIndex: currentIndex,
        onTap: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
          ref.read(bottomNavBarProvider.notifier).state = value;
        },
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[400]
            : CupertinoColors.systemGrey,
        enableFeedback: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, size: 25),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search, size: 25),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_rounded, size: 25),
            label: "Savings",
          ),
        ],
      ),
    );
  }
}
