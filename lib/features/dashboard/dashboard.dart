import 'package:expense_tracker_flutter/features/expense/screen/search_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          currentIndex == 0 ? const HomeScreen() : const SearchExpenseScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        unselectedItemColor: CupertinoColors.systemGrey,
        onTap: (value) {
          ref.read(bottomNavBarProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.search,
              ),
              label: "Search"),
        ],
      ),
    );
  }
}
