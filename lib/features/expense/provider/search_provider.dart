import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/firebase_constants.dart';

final searchExpenseProvider = ChangeNotifierProvider((ref) => SearchNotifier());

class SearchNotifier extends ChangeNotifier {
  List<DocumentSnapshot> _documents = [];
  List<DocumentSnapshot> filteredDocuments = [];
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool hasMoreData = true;

  String activeSearchQuery = '';
  String activeCategory = 'All';

  void _applyFilters() {
    filteredDocuments = _documents.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final name = (data['name'] as String? ?? '').toLowerCase();
      final category = (data['category'] as String? ?? '').toLowerCase();

      final matchesQuery =
          activeSearchQuery.isEmpty || name.contains(activeSearchQuery.toLowerCase());
      final matchesCategory =
          activeCategory == 'All' || category == activeCategory.toLowerCase();

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

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setHasMoreData(bool hasMore) {
    hasMoreData = hasMore;
    notifyListeners();
  }

  Future<void> fetchSearchResults(String query) async {
    isLoading = true;
    activeSearchQuery = query;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.expenseCollection)
          .get();

      _documents = snapshot.docs;
      hasMoreData = false;
    } catch (e) {
      debugPrint('fetchSearchResults error: $e');
    } finally {
      isLoading = false;
      _applyFilters();
    }
  }

  void updateExpenses({
    required List<DocumentSnapshot> newDocuments,
    DocumentSnapshot? newLastDocument,
    required bool hasMore,
  }) {
    _documents = List.from(_documents)..addAll(newDocuments);
    lastDocument = newLastDocument;
    hasMoreData = hasMore;
    _applyFilters();
  }

  void sortFilteredDocuments(List<DocumentSnapshot> sorted) {
    filteredDocuments = sorted;
    notifyListeners();
  }

  void reset() {
    _documents = [];
    filteredDocuments = [];
    lastDocument = null;
    hasMoreData = true;
    activeSearchQuery = '';
    activeCategory = 'All';
    notifyListeners();
  }
}
