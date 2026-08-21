import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/features/expense/screen/search_screen.dart';
import 'package:expense_tracker_flutter/features/savings/screen/savings_screen.dart';
import 'package:expense_tracker_flutter/features/upcoming_expenses/screen/upcoming_expenses_screen.dart';
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
        return const UpcomingExpensesScreen();
      case 2:
        return const SearchExpenseScreen();
      case 3:
        return const SavingsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.3
                    : 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            ref.read(bottomNavBarProvider.notifier).state = value;
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[500]
              : const Color(0xff94A3B8),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          type: BottomNavigationBarType.fixed,
          enableFeedback: true,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(CupertinoIcons.home, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(CupertinoIcons.house_fill, size: 24),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.event_note_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.event_note_rounded, size: 24),
              ),
              label: "Upcoming",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(CupertinoIcons.search, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(CupertinoIcons.search, size: 26),
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.savings_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.savings_rounded, size: 24),
              ),
              label: "Savings",
            ),
          ],
        ),
      ),
    );
  }
}
