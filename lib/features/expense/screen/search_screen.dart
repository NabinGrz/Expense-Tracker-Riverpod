import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_color.dart';
import '../../../helper/expense_query_helper.dart';
import '../../../models/expense_model.dart';
import '../../../shared/widget/expense_tile.dart';
import '../provider/search_provider.dart';

class SearchExpenseScreen extends ConsumerStatefulWidget {
  const SearchExpenseScreen({super.key});

  @override
  _SearchExpenseScreenState createState() => _SearchExpenseScreenState();
}

class _SearchExpenseScreenState extends ConsumerState<SearchExpenseScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  SearchNotifier get searchProviderNotifier =>
      ref.read(searchExpenseProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExpenses();

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent * 0.9 &&
            !searchProviderNotifier.isLoading &&
            searchProviderNotifier.hasMoreData) {
          _loadExpenses();
        }
      });

      _searchController.addListener(() {
        final query = _searchController.text;
        if (query.isEmpty) {
          searchProviderNotifier.filterExpenses('');
        } else {
          searchProviderNotifier.fetchSearchResults(query);
        }
      });
    });
  }

  Future<void> _loadExpenses() async {
    if (_searchController.text.isEmpty) {
      searchProviderNotifier.setLoading(true);

      final snapshot = await ExpenseQueryHelper.getPaginatedExpenseAsFuture(
        collectionPath: 'expenses',
        limit: 20,
        lastDocument: searchProviderNotifier.lastDocument,
      );

      if (snapshot != null && snapshot.docs.isNotEmpty) {
        searchProviderNotifier.updateExpenses(
          newDocuments: snapshot.docs,
          newLastDocument: snapshot.docs.last,
          hasMore: snapshot.docs.length == 20,
        );
      } else {
        searchProviderNotifier.setHasMoreData(false);
      }
      searchProviderNotifier.setLoading(false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  SearchNotifier get watchSearchExpenses => ref.watch(searchExpenseProvider);
  @override
  Widget build(BuildContext context) {
    // return CupertinoPageScaffold();
    return CupertinoPageScaffold(
      child: RefreshIndicator.adaptive(
        color: Colors.white,
        // color: AppColor.primary,
        onRefresh: () async {
          await _loadExpenses();
          if (context.mounted) {
            FocusScope.of(context).unfocus();
          }
        },
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          slivers: [
            CupertinoSliverNavigationBar(
              automaticBackgroundVisibility: true,
              largeTitle: Text(
                'All Expenses',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColor.primary,
                ),
              ),
              trailing: PopupMenuButton(
                // iconColor: Colors.white,.
                iconColor: AppColor.primary,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () => sortBy(true),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: const Text("Sort By Amount"),
                    ),
                    PopupMenuItem(
                      onTap: () => sortBy(false),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: const Text("Sort By Date"),
                    ),
                  ];
                },
              ),
              bottom: _NavigationBarSearchField(
                child: CupertinoSearchTextField(
                  controller: _searchController,
                  placeholder: 'Search expenses',
                  style: const TextStyle(color: CupertinoColors.black),
                  onSuffixTap: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                    _loadExpenses();
                  },
                ),
              ),
              // bottomMode: NavigationBarBottomMode.always,
            ),
            SliverToBoxAdapter(
                child: watchSearchExpenses.isLoading
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink()),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < watchSearchExpenses.filteredDocuments.length) {
                    final mapData = watchSearchExpenses.filteredDocuments[index]
                        .data() as Map<String, dynamic>;
                    mapData['docId'] =
                        watchSearchExpenses.filteredDocuments[index].id;
                    final expense = Expense.fromMap(mapData);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: ExpenseTile(
                        key: Key("$index"),
                        expenseData: expense,
                        isFilter: false,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                childCount: watchSearchExpenses.filteredDocuments.length,
              ),
            ),
            if (!watchSearchExpenses.hasMoreData &&
                watchSearchExpenses.filteredDocuments.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Text('No expenses found.'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void sortBy(bool isAmount) {
    watchSearchExpenses.filteredDocuments.sort((a, b) {
      var aData = Expense.fromMap(a.data() as Map<String, dynamic>);
      var bData = Expense.fromMap(b.data() as Map<String, dynamic>);
      return isAmount
          ? aData.amount.compareTo(bData.amount)
          : aData.createAt.compareTo(bData.createAt);
    });
    searchProviderNotifier
        .updateSortedExpenses(watchSearchExpenses.filteredDocuments);
  }
}

class _NavigationBarSearchField extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget child;
  const _NavigationBarSearchField({required this.child});

  static const double padding = 12.0;
  static const double searchFieldHeight = 35.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding,
      ),
      child: SizedBox(height: searchFieldHeight, child: child),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(searchFieldHeight + padding * 2);
}
