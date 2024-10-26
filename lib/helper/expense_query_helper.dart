import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';

class ExpenseQueryHelper {
  ExpenseQueryHelper._();

  static Stream<QuerySnapshot<Map<String, dynamic>>>? getExpense() =>
      FirebaseQueryHelper.getCollectionAsStream(collectionPath: "expenses");
  static Stream<QuerySnapshot<Map<String, dynamic>>>? getPaginatedExpense(
          int limit) =>
      FirebaseQueryHelper.getPaginatedCollectionAsStream(
          collectionPath: "expenses", limit: limit);

  static Future<QuerySnapshot<Map<String, dynamic>>>? getExpenseAsFuture() =>
      FirebaseQueryHelper.getCollectionAsFuture(collectionPath: "expenses");
  static Future<QuerySnapshot<Map<String, dynamic>>>?
      getPaginatedExpenseAsFuture({
    required String collectionPath,
    required int limit,
    DocumentSnapshot? lastDocument,
  }) =>
          // FirebaseQueryHelper.getPaginatedCollectionAsFuture(
          //     collectionPath: "expenses", limit: limit);
          FirebaseQueryHelper.getPaginatedCollectionAsFuture(
              collectionPath: collectionPath,
              limit: limit,
              lastDocument: lastDocument);

  static Stream<QuerySnapshot<Map<String, dynamic>>>? getExpenseCategory() =>
      FirebaseQueryHelper.getCollectionAsStream(
          collectionPath: "expense-categories");

  static Future<void> createExpense(
      Expense expense, String cashAmount, String bankAmount) async {
    await FirebaseQueryHelper.firebaseFireStore
        .collection("expenses")
        .add(expense.toMap());

    final data = expense.isCash
        ? {"cash": "${int.parse(cashAmount) - expense.amount}"}
        : {"bank": "${int.parse(bankAmount) - expense.amount}"};

    FirebaseQueryHelper.updateDocumentOfCollection(
        data: data, collectionID: "balance", docID: "G0sKt8y5dvwNsTv63m2f");
  }

  static void updateExpense(Map<String, dynamic> newData, String id,
      String cashAmount, String bankAmount, int? previousExpenseAmount) async {
    final ref =
        FirebaseQueryHelper.firebaseFireStore.collection("expenses").doc(id);
    await ref.update(newData);

    final amount = newData['amount'] as int;
    final data = newData['isCash']
        ? {
            "cash":
                "${(int.parse(cashAmount) + (previousExpenseAmount ?? 0) - amount)}"
          }
        : {
            "bank":
                "${(int.parse(bankAmount) + (previousExpenseAmount ?? 0) - amount)}"
          };

    FirebaseQueryHelper.updateDocumentOfCollection(
        data: data, collectionID: "balance", docID: "G0sKt8y5dvwNsTv63m2f");
  }

  static void updateExpenseAmounWhenTypeChange({
    required Map<String, dynamic> newData,
    required String id,
    required bool isCash,
    required String oldAmount,
    required String newAmount,
    required String cashAmount,
    required String bankAmount,
  }) async {
    final ref =
        FirebaseQueryHelper.firebaseFireStore.collection("expenses").doc(id);
    await ref.update(newData);

    int oA = int.tryParse(oldAmount) ?? 0;
    int nA = int.tryParse(newAmount) ?? 0;

    int existingCashAmount = int.tryParse(cashAmount) ?? 0;
    int existingBankAmount = int.tryParse(bankAmount) ?? 0;
    if (oA != 0 && nA != 0) {
      if (isCash) {
        final data = {
          "bank": "${existingBankAmount + oA}",
          "cash": "${existingCashAmount - nA}",
        };
        FirebaseQueryHelper.updateDocumentOfCollection(
            data: data, collectionID: "balance", docID: "G0sKt8y5dvwNsTv63m2f");
      } else {
        final data = {
          "cash": "${existingCashAmount + oA}",
          "bank": "${existingBankAmount - nA}",
        };
        FirebaseQueryHelper.updateDocumentOfCollection(
            data: data, collectionID: "balance", docID: "G0sKt8y5dvwNsTv63m2f");
      }
    }
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
