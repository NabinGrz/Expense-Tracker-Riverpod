import 'dart:convert';

import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/home/provider/home_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/tab_bar_provider.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_analytics_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../models/expense_model.dart';
import '../../../shared/widget/sort_by_widget.dart';
import '../../../utils/expense_utils.dart';
import '../widgets/balance_card.dart';
import '../widgets/date_filter_row.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_expenses_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Expense> originalExpenseList = [];
  final sortedExpenseSubject = BehaviorSubject<List<Expense>>();

  @override
  void initState() {
    ExpenseQueryHelper.getExpenseAsFuture()?.then(
      (value) {
        final data = value.docs.map(
          (element) {
            final expense = Expense.fromJson(jsonEncode(element.data()));
            expense.docId = element.id;
            return expense;
          },
        ).toList();

        originalExpenseList = List.from(data);
        sortedExpenseSubject.add(data);
      },
    );
    listenToChangesOnExpenses();
    super.initState();
  }

  void listenToChangesOnExpenses() {
    ExpenseQueryHelper.getExpense()?.listen(
      (event) {
        final data = event.docs.map(
          (element) {
            final expense = Expense.fromJson(jsonEncode(element.data()));
            expense.docId = element.id;
            return expense;
          },
        ).toList();
        final grouped = data.totalAmountByCategory();

        originalExpenseList = List.from(data);
        sortedExpenseSubject.add([]);
        sortedExpenseSubject.add(data);
      },
    );
  }

  void listenToSorting() {
    ref.listen(
      sortByProvider,
      (previous, next) {
        sortedExpenseSubject.add(List.from(originalExpenseList));
        final listedExpense = sortedExpenseSubject.valueOrNull;
        switch (next) {
          case SortBy.none:
            sortedExpenseSubject.add(originalExpenseList);
            break;
          case SortBy.hightolow:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.hightolow);
            sortedExpenseSubject.add(listedExpense ?? []);
            break;
          case SortBy.lowtohigh:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.lowtohigh);
            sortedExpenseSubject.add(listedExpense ?? []);
            break;
          case SortBy.highTolowDate:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.highTolowDate);
            sortedExpenseSubject.add(listedExpense ?? []);
            break;
          case SortBy.lowTohighDate:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.lowTohighDate);
            sortedExpenseSubject.add(listedExpense ?? []);
            break;
          default:
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    listenToSorting();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SvgPicture.asset("assets/images/header.svg"),
                SvgPicture.asset("assets/images/header_background.svg"),
                const BalanceCard()
              ],
            ),
            22.hGap,
            const DateFilterRow(),
            16.hGap,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Expenses List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  2.hGap,
                  Text(
                    "Total Spend: Rs ${ref.watch(dateFilterProvider).totalAmount}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff666666),
                    ),
                  ),
                  12.hGap,
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset("assets/images/search.svg"),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 18),
                      hintText: "Search...",
                      hintStyle: const TextStyle(
                        color: Color(0xff888888),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  30.hGap,
                  const ExpenseAnalyticTabBar(),
                  20.hGap,
                  if (ref.watch(tabProvider) == SelectedTab.expense) ...{
                    const SortByWidget(),
                    20.hGap,
                  },
                  const Divider(),
                  10.hGap,
                  HomeExpenseList(
                    sortedExpenseSubject: sortedExpenseSubject,
                    ref: ref,
                  ),
                  130.hGap,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
