import 'dart:convert';

import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/expense/provider/home_provider.dart';
import 'package:expense_tracker_flutter/shared/provider/sort_by_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../helper/firebase_query_handler.dart';
import '../../../models/expense_model.dart';
import '../../../utils/expense_utils.dart';
import '../entity/home_entity.dart';
import '../widgets/balance_card.dart';
import '../widgets/create_expense_dialog.dart';
import '../widgets/date_filter_row.dart';
import '../widgets/home_body_content.dart';
import '../widgets/restaurant_alert_banner.dart';
import '../widgets/sliver_home_app_bar.dart';

final bottomNavBarProvider = StateProvider((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final searchController = TextEditingController();
  List<Expense> originalExpenseList = [];
  HomeNotifier get controller => ref.read(homeEntityProvider.notifier);
  HomeEntity get homeEntity => ref.watch(homeEntityProvider);

  void _initialize() {
    ExpenseQueryHelper.getExpenseAsFuture()?.then((value) {
      final data = value.docs.map((element) {
        final expense = Expense.fromJson(jsonEncode(element.data()));
        expense.docId = element.id;
        return expense;
      }).toList();

      originalExpenseList = List.from(data);
      controller.sortedExpenseSubject.add(data);
    });
    listenToChangesOnExpenses();
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void listenToChangesOnExpenses() {
    ExpenseQueryHelper.getExpense()?.listen((event) {
      final data = event.docs.map((element) {
        final expense = Expense.fromJson(jsonEncode(element.data()));
        expense.docId = element.id;
        return expense;
      }).toList();
      originalExpenseList = List.from(data);
      controller.sortedExpenseSubject.add(data);
    });
  }

  void listenToSorting() {
    ref.listen(homeSortByProvider, (previous, next) {
      final listedExpense = List<Expense>.from(originalExpenseList);
      switch (next) {
        case SortBy.none:
          controller.sortedExpenseSubject.add(originalExpenseList);
          break;
        case SortBy.hightolow:
          ExpenseUtils.sortBy(listedExpense, SortBy.hightolow);
          controller.sortedExpenseSubject.add(listedExpense);
          break;
        case SortBy.lowtohigh:
          ExpenseUtils.sortBy(listedExpense, SortBy.lowtohigh);
          controller.sortedExpenseSubject.add(listedExpense);
          break;
        case SortBy.highTolowDate:
          ExpenseUtils.sortBy(listedExpense, SortBy.highTolowDate);
          controller.sortedExpenseSubject.add(listedExpense);
          break;
        case SortBy.lowTohighDate:
          ExpenseUtils.sortBy(listedExpense, SortBy.lowTohighDate);
          controller.sortedExpenseSubject.add(listedExpense);
          break;
        case SortBy.ascending:
          ExpenseUtils.sortBy(listedExpense, SortBy.ascending);
          controller.sortedExpenseSubject.add(listedExpense);
          break;
        case SortBy.descending:
          ExpenseUtils.sortBy(listedExpense, SortBy.descending);
          controller.sortedExpenseSubject.add(listedExpense);
          break;
        default:
      }
    });
  }

  //  HapticFeedback.lightImpact();
  //         FirebaseQueryHelper.getSingleDocumentAsFuture(
  //             collectionPath: FirebaseConstants.balanceCollection,
  //             docID: FirebaseConstants.balanceDocID);
  //         controller.sortedExpenseSubject.add(originalExpenseList);
  //         searchController.clear();
  //         FocusScope.of(context).unfocus();
  @override
  Widget build(BuildContext context) {
    listenToSorting();
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          showDialog(
            context: context,
            builder: (context) =>
                const CreateUpdateDialog(isUpdate: false, docId: ""),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverHomeAppBar(onPressed: () {}),
          // SliverToBoxAdapter(child: Text(NepaliDateTime.now().toString())),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              HapticFeedback.lightImpact();
              await FirebaseQueryHelper.getSingleDocumentAsFuture(
                collectionPath: FirebaseConstants.balanceCollection,
                docID: FirebaseConstants.balanceDocID,
              );
              if (mounted) {
                controller.sortedExpenseSubject.add(originalExpenseList);
                searchController.clear();
                FocusScope.of(context).unfocus();
              }
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              BalanceCard(
                sortedExpenseSubject: controller.sortedExpenseSubject,
              ),
              const RestaurantAlertBanner(),
              30.hGap,
              const DateFilterRow(),
              16.hGap,
              HomeBodyContent(
                controller: controller,
                homeEntity: homeEntity,
                searchController: searchController,
                originalExpenseList: originalExpenseList,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
