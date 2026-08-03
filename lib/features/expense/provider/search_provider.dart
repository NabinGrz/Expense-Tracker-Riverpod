import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/expense_model.dart';

final searchExpenseProvider = ChangeNotifierProvider((ref) => SearchNotifier());

class SearchNotifier extends ChangeNotifier {
  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> filteredDocuments = [];
  List<DocumentSnapshot> sortedDocuments = [];
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool hasMoreData = true;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  String activeSearchQuery = '';
  String activeCategory = 'All';

  void _applyFilters() {
    filteredDocuments = documents.where((doc) {
      final expense = Expense.fromMap(doc.data() as Map<String, dynamic>);
      final matchesQuery = activeSearchQuery.isEmpty ||
          expense.name.toLowerCase().contains(activeSearchQuery.toLowerCase());
      final matchesCategory = activeCategory == 'All' ||
          expense.category.toLowerCase() == activeCategory.toLowerCase();
      return matchesQuery && matchesCategory;
    }).toList();
    notifyListeners();
  }

  void filterExpenses(String query) {
    activeSearchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    activeCategory = category;
    _applyFilters();
  }

  Future<void> fetchSearchResults(String query) async {
    isLoading = true;
    activeSearchQuery = query;
    notifyListeners();

    final snapshot =
        await FirebaseFirestore.instance.collection('expenses').get();

    if (snapshot.docs.isNotEmpty) {
      documents = snapshot.docs;
      _applyFilters();
      hasMoreData = false;
    } else {
      filteredDocuments = [];
      hasMoreData = false;
    }
    isLoading = false;
    notifyListeners();
  }

  void updateSortedExpenses(List<DocumentSnapshot<Object?>> val) {
    sortedDocuments = val;
    notifyListeners();
  }

  void updateExpenses({
    required List<DocumentSnapshot> newDocuments,
    DocumentSnapshot? newLastDocument,
    required bool hasMore,
  }) {
    documents.addAll(newDocuments);
    lastDocument = newLastDocument;
    hasMoreData = hasMore;
    filterExpenses('');
    notifyListeners();
  }

  void setHasMoreData(bool hasMore) {
    hasMoreData = hasMore;
    notifyListeners();
  }
}
