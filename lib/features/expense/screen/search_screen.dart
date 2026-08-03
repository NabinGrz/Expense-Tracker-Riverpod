import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_color.dart';
import '../../../helper/expense_query_helper.dart';
import '../../../models/expense_model.dart';
import '../../../shared/widget/custom_empty_state.dart';
import '../../../shared/widget/expense_tile.dart';
import '../provider/search_provider.dart';

class SearchExpenseScreen extends ConsumerStatefulWidget {
  const SearchExpenseScreen({super.key});

  @override
  _SearchExpenseScreenState createState() => _SearchExpenseScreenState();
}

class _SearchExpenseScreenState extends ConsumerState<SearchExpenseScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: CupertinoPageScaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: RefreshIndicator.adaptive(
        color: AppColor.primary,
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
              backgroundColor: theme.scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xff334155)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              automaticBackgroundVisibility: false,
              largeTitle: Text(
                'All Expenses',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColor.primary,
                ),
              ),
              trailing: PopupMenuButton(
                icon: Icon(
                  Icons.sort_rounded,
                  color: isDark ? Colors.white : AppColor.primary,
                ),
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.1),
                surfaceTintColor: theme.cardColor,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                menuPadding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(16),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () => sortBy(true),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            size: 20,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                          12.wGap,
                          Text(
                            "Sort By Amount",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => sortBy(false),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                          12.wGap,
                          Text(
                            "Sort By Date",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    final hasText = value.text.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xff1E293B)
                            : const Color(0xffF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? (hasText
                                  ? const Color(0xff3B82F6)
                                  : const Color(0xff334155))
                              : (hasText
                                  ? const Color(0xff2563EB)
                                  : const Color(0xffE2E8F0)),
                          width: hasText ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.25 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xff1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: "Search expenses...",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xff64748B)
                                : const Color(0xff94A3B8),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 14, right: 10),
                            child: Icon(
                              Icons.search_rounded,
                              size: 22,
                              color: isDark
                                  ? (hasText
                                      ? const Color(0xff60A5FA)
                                      : const Color(0xff64748B))
                                  : (hasText
                                      ? const Color(0xff2563EB)
                                      : const Color(0xff94A3B8)),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          suffixIcon: hasText
                              ? InkWell(
                                  onTap: () {
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                    _loadExpenses();
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isDark
                                            ? const Color(0xff334155)
                                            : const Color(0xffE2E8F0),
                                      ),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 14,
                                        color: isDark
                                            ? const Color(0xff94A3B8)
                                            : const Color(0xff64748B),
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: watchSearchExpenses.isLoading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index < watchSearchExpenses.filteredDocuments.length) {
                  final mapData =
                      watchSearchExpenses.filteredDocuments[index].data()
                          as Map<String, dynamic>;
                  mapData['docId'] =
                      watchSearchExpenses.filteredDocuments[index].id;
                  final expense = Expense.fromMap(mapData);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: ExpenseTile(
                      key: Key("$index"),
                      expenseData: expense,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }, childCount: watchSearchExpenses.filteredDocuments.length),
            ),
            if (!watchSearchExpenses.hasMoreData &&
                watchSearchExpenses.filteredDocuments.isEmpty)
              const SliverToBoxAdapter(
                child: CustomEmptyState(
                  icon: CupertinoIcons.search,
                  title: "No expenses found",
                  subtitle: "Try adjusting your search query",
                ),
              ),
          ],
        ),
      ),
    ),
  );
  }

  void sortBy(bool isAmount) {
    watchSearchExpenses.filteredDocuments.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;
      final bData = b.data() as Map<String, dynamic>;
      if (isAmount) {
        final aAmount = aData['amount'] as num;
        final bAmount = bData['amount'] as num;
        return aAmount.compareTo(bAmount);
      } else {
        final aDate = aData['createAt'] as String;
        final bDate = bData['createAt'] as String;
        return aDate.compareTo(bDate);
      }
    });
    searchProviderNotifier.updateSortedExpenses(
      watchSearchExpenses.filteredDocuments,
    );
  }
}
