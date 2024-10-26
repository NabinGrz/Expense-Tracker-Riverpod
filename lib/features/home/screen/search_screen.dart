import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helper/expense_query_helper.dart';
import '../../../models/expense_model.dart';
import '../../../shared/widget/expense_tile.dart';

class SearchExpenseScreen extends StatefulWidget {
  const SearchExpenseScreen({super.key});

  @override
  _SearchExpenseScreenState createState() => _SearchExpenseScreenState();
}

class _SearchExpenseScreenState extends State<SearchExpenseScreen> {
  final List<DocumentSnapshot> _documents = [];
  final ScrollController _scrollController = ScrollController();
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMoreData = true;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadExpenses();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.9 &&
          !_isLoading &&
          _hasMoreData) {
        _loadExpenses();
      }
    });
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });

    final snapshot = await ExpenseQueryHelper.getPaginatedExpenseAsFuture(
      collectionPath: 'expenses',
      limit: _limit,
      lastDocument: _lastDocument,
    );

    if (snapshot != null && snapshot.docs.isNotEmpty) {
      setState(() {
        _documents.addAll(snapshot.docs);
        _lastDocument = snapshot.docs.last;
        _hasMoreData = snapshot.docs.length == _limit;
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasMoreData = false;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CupertinoSliverNavigationBar(
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(CupertinoIcons.left_chevron),
            ),
            alwaysShowMiddle: true,
            largeTitle: const Text(
              'Recent Expenses',
              style: TextStyle(fontFamily: 'Manrope', fontSize: 20),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 60.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index < _documents.length) {
                  final expense = Expense.fromMap(
                      _documents[index].data() as Map<String, dynamic>);
                  return ExpenseTile(expenseData: expense, isFilter: false);
                } else if (_isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SizedBox.shrink();
                }
              },
              childCount: _documents.length + (_hasMoreData ? 1 : 0),
            ),
          ),
        ],
      ),
    );
  }
}
