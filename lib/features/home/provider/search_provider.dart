import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/expense_model.dart';

final searchProvider = ChangeNotifierProvider((ref) => SearchNotifier());

class SearchNotifier extends ChangeNotifier {
  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> filteredDocuments = [];
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool hasMoreData = true;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void filterExpenses(String query) {
    if (query.isEmpty) {
      filteredDocuments = List.from(documents);
    } else {
      filteredDocuments = documents.where((doc) {
        final expense = Expense.fromMap(doc.data() as Map<String, dynamic>);
        return expense.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchSearchResults(String query) async {
    isLoading = true;
    notifyListeners();

    final snapshot =
        await FirebaseFirestore.instance.collection('expenses').get();

    List<DocumentSnapshot> filteredExpenses = snapshot.docs.where((doc) {
      final name = doc['name'] as String;
      return name.toLowerCase().contains(query);
    }).toList();
    if (snapshot.docs.isNotEmpty) {
      filteredDocuments = filteredExpenses;
      hasMoreData = false;
    } else {
      filteredDocuments = [];
      hasMoreData = false;
    }
    isLoading = false;
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
