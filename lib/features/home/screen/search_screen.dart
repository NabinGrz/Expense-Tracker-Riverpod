import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      ref.read(searchProvider.notifier);

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

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
              child: const Icon(CupertinoIcons.left_chevron),
            ),
            largeTitle: const Text(
              'Recent Expenses',
              style: TextStyle(fontFamily: 'Manrope', fontSize: 20),
            ),
            trailing: InkWell(
              onTap: () {
                _loadExpenses();
                FocusScope.of(context).unfocus();
              },
              child: const Icon(
                CupertinoIcons.refresh,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
          ),
          SliverToBoxAdapter(
            child: searchState.isLoading
                ? const LinearProgressIndicator()
                : const SizedBox.shrink(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < searchState.filteredDocuments.length) {
                  final expense = Expense.fromMap(
                    searchState.filteredDocuments[index].data()
                        as Map<String, dynamic>,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: ExpenseTile(expenseData: expense, isFilter: false),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              childCount: searchState.filteredDocuments.length,
            ),
          ),
          if (!searchState.hasMoreData && searchState.filteredDocuments.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Text('No expenses found.'),
              ),
            ),
        ],
      ),
    );
  }
}
