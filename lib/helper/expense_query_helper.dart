import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';

class ExpenseQueryHelper {
  ExpenseQueryHelper._();

  static Stream<QuerySnapshot<Map<String, dynamic>>>? getExpense() =>
      FirebaseQueryHelper.getCollectionAsStream(collectionPath: "expenses");

  static Future<QuerySnapshot<Map<String, dynamic>>>? getExpenseAsFuture() =>
      FirebaseQueryHelper.getCollectionAsFuture(collectionPath: "expenses");

  static Stream<QuerySnapshot<Map<String, dynamic>>>? getExpenseCategory() =>
      FirebaseQueryHelper.getCollectionAsStream(
          collectionPath: "expense-categories");

  static Future<void> createExpense(Expense expense) async {
    await FirebaseQueryHelper.firebaseFireStore
        .collection("expenses")
        .add(expense.toMap());
  }

  static void updateExpense(Map<String, dynamic> newData, String id) async {
    final ref =
        FirebaseQueryHelper.firebaseFireStore.collection("expenses").doc(id);
    await ref.update(newData);
  }

  static void deleteExpense(String id) async {
    final ref =
        FirebaseQueryHelper.firebaseFireStore.collection("expenses").doc(id);
    await ref.delete();
  }

  static Stream<List<Expense>> getSelectedDateRangeExpenses(
      DateTime startDate, DateTime endDate) {
    final expenses = FirebaseQueryHelper.firebaseFireStore
        .collection("expenses")
        .snapshots()
        .map(
      (event) {
        final filteredExpense = event.docs.where(
          (element) {
            final expense = Expense.fromJson(jsonEncode(element.data()));
            final expenseDate = DateTime.parse(expense.createAt);
            return expenseDate.isDateInRange(startDate, endDate);
          },
        ).toList();

        return filteredExpense.map(
          (element) {
            return Expense.fromJson(jsonEncode(element.data()));
          },
        ).toList();
      },
    );

    return expenses;
  }

  static Stream<List<Expense>> getSelectedDateExpenses(DateTime date) {
    final expenses = FirebaseQueryHelper.firebaseFireStore
        .collection("expenses")
        .snapshots()
        .map(
      (event) {
        final filteredExpense = event.docs.where(
          (element) {
            final expense = Expense.fromJson(jsonEncode(element.data()));
            final expenseDate = DateTime.parse(expense.createAt);
            return expenseDate.isSameDateAs(date);
          },
        ).toList();

        return filteredExpense.map(
          (element) {
            return Expense.fromJson(jsonEncode(element.data()));
          },
        ).toList();
      },
    );

    return expenses;
  }
}
