import 'package:expense_tracker_flutter/features/expense/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    // return CupertinoTabScaffold(
    //   tabBar: CupertinoTabBar(
    //     items: const <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //           icon: Icon(CupertinoIcons.home), label: 'Home'),
    //       BottomNavigationBarItem(
    //           icon: Icon(CupertinoIcons.search), label: 'Search'),
    //     ],
    //   ),
    //   tabBuilder: (BuildContext context, int index) {
    //     return CupertinoTabView(
    //       builder: (BuildContext context) {
    //         return index == 0
    //             ? const HomeScreen()
    //             : const SearchExpenseScreen();
    //         // return Center(child: Text('Content of tab $index'));
    //       },
    //     );
    //   },
    // );
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
                  // color: CupertinoColors.placeholderText,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  // CupertinoIcons.searxh
                  CupertinoIcons.search,
                  // color: CupertinoColors.placeholderText,
                ),
                label: "Search"),
          ]),
    );
  }
}
