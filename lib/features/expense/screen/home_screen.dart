import 'dart:convert';

import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/expense/provider/home_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/tab_bar_provider.dart';
import 'package:expense_tracker_flutter/shared/widget/expense_analytics_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../helper/firebase_query_handler.dart';
import '../../../models/expense_model.dart';
import '../../../shared/widget/sort_by_widget.dart';
import '../../../utils/expense_utils.dart';
import '../entity/home_entity.dart';
import '../widgets/balance_card.dart';
import '../widgets/create_expense_dialog.dart';
import '../widgets/date_filter_row.dart';
import '../widgets/search_text_field.dart';
import '../widgets/sliver_home_app_bar.dart';
import '../widgets/home_expenses_list.dart';

final bottomNavBarProvider = StateProvider((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final updater = ShorebirdUpdater();
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
    updater.readCurrentPatch().then((currentPatch) {
      if (currentPatch != null) {
        print('The current patch number is: ${currentPatch.number}');
      }
    });
    _initialize();

    super.initState();
  }

  Future<void> _checkForUpdates() async {
    // Check whether a new update is available.
    final status = await updater.checkForUpdate();

    if (status == UpdateStatus.outdated) {
      try {
        // Perform the update
        await updater.update();
      } on UpdateException {
        // Handle any errors that occur while updating.
      }
    }
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
          case SortBy.ascending:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.ascending);
            controller.sortedExpenseSubject.add(listedExpense ?? []);
            break;
          case SortBy.descending:
            ExpenseUtils.sortBy(listedExpense ?? [], SortBy.descending);
            controller.sortedExpenseSubject.add(listedExpense ?? []);
            break;
          default:
        }
      },
    );
  }

  //  HapticFeedback.lightImpact();
  //         FirebaseQueryHelper.getSingleDocumentAsFuture(
  //             collectionPath: "balance", docID: "G0sKt8y5dvwNsTv63m2f");
  //         controller.sortedExpenseSubject.add(originalExpenseList);
  //         searchController.clear();
  //         FocusScope.of(context).unfocus();
  @override
  Widget build(BuildContext context) {
    listenToSorting();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          showDialog(
            context: context,
            builder: (context) {
              return const CreateUpdateDialog(
                isUpdate: false,
                docId: "",
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverHomeAppBar(onPressed: () async {
            await _checkForUpdates();
          }),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              HapticFeedback.lightImpact();
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
              StreamBuilder(
                  stream: controller.sortedExpenseSubject,
                  builder: (context, snapshot) {
                    List<Expense>? expenses = [];
                    expenses = controller.dateWiseExpenses(expenses, snapshot,
                        ref.watch(homeEntityProvider).dateFilter);
                    return (expenses?.isEmpty != true)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Expenses List",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                2.hGap,
                                Text(
                                  "Total Spend: Rs ${homeEntity.totalAmount.toCurrency}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff666666),
                                  ),
                                ),
                                16.hGap,
                                SearchTextField(
                                    searchController: searchController,
                                    homeEntity: homeEntity,
                                    controller: controller,
                                    originalExpenseList: originalExpenseList),
                                20.hGap,
                                const ExpenseAnalyticTabBar(),
                                20.hGap,
                                if (ref.watch(hometabProvider) ==
                                    SelectedTab.expense) ...{
                                  const SortByWidget(),
                                  20.hGap,
                                },
                                const HomeExpenseList(),
                                50.hGap,
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/empty_expenses.webp",
                                  height: 150,
                                ),
                                const Text(
                                  "Oops...There are no expenses",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                  }),
            ]),
          ),
        ],
      ),
    );
  }
}
