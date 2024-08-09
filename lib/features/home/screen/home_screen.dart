import 'dart:convert';

import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/home/provider/home_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/tab_bar_provider.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_analytics_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../helper/firebase_query_handler.dart';
import '../../../models/expense_model.dart';
import '../../../shared/widget/sort_by_widget.dart';
import '../../../utils/expense_utils.dart';
import '../entity/home_entity.dart';
import '../widgets/balance_card.dart';
import '../widgets/date_filter_row.dart';
import '../widgets/sliver_home_app_bar.dart';
import '../widgets/home_expenses_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final searchController = TextEditingController();
  List<Expense> originalExpenseList = [];
  HomeNotifier get controller => ref.read(homeEntityProvider.notifier);
  HomeEntity get homeEntity => ref.watch(homeEntityProvider);
  void _initialize() {
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
        controller.sortedExpenseSubject.add(data);
      },
    );
    listenToChangesOnExpenses();
  }

  @override
  void initState() {
    _initialize();
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
        originalExpenseList = List.from(data);
        controller.sortedExpenseSubject.add([]);
        controller.sortedExpenseSubject.add(data);
      },
    );
  }

  void listenToSorting() {
    ref.listen(
      homeSortByProvider,
      (previous, next) {
        controller.sortedExpenseSubject.add(List.from(originalExpenseList));
        final listedExpense = controller.sortedExpenseSubject.valueOrNull;
        switch (next) {
          case SortBy.none:
            controller.sortedExpenseSubject.add(originalExpenseList);
            break;
          case SortBy.hightolow:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.hightolow);
            controller.sortedExpenseSubject.add(listedExpense ?? []);
            break;
          case SortBy.lowtohigh:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.lowtohigh);
            controller.sortedExpenseSubject.add(listedExpense ?? []);
            break;
          case SortBy.highTolowDate:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.highTolowDate);
            controller.sortedExpenseSubject.add(listedExpense ?? []);
            break;
          case SortBy.lowTohighDate:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.lowTohighDate);
            controller.sortedExpenseSubject.add(listedExpense ?? []);
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
      backgroundColor: Colors.white,
      extendBody: true,
      body: CustomScrollView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        slivers: [
          SliverHomeAppBar(
            onRefresh: () {
              //     _initialize();
              FirebaseQueryHelper.getSingleDocumentAsFuture(
                  collectionPath: "balance", docID: "G0sKt8y5dvwNsTv63m2f");
              controller.sortedExpenseSubject.add(originalExpenseList);
              searchController.clear();
              FocusScope.of(context).unfocus();
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BalanceCard(
                sortedExpenseSubject: controller.sortedExpenseSubject,
              ),
              30.hGap,
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
                      "Total Spend: Rs ${homeEntity.totalAmount}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                      ),
                    ),
                    12.hGap,
                    TextFormField(
                      controller: searchController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final searchedExpenses = homeEntity.expenses?.where(
                            (element) {
                              return element.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.category
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                            },
                          ).toList();
                          controller.sortedExpenseSubject
                              .add(searchedExpenses ?? []);
                        } else {
                          controller.sortedExpenseSubject
                              .add(originalExpenseList);
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset("assets/images/search.svg"),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            controller.sortedExpenseSubject
                                .add(originalExpenseList);
                            searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.clear),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 18),
                        hintText: "Search expense/category name...",
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
                    if (ref.watch(hometabProvider) == SelectedTab.expense) ...{
                      const SortByWidget(),
                      20.hGap,
                    },
                    const Divider(),
                    10.hGap,
                    const HomeExpenseList(),
                    130.hGap,
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
