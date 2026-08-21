import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:expense_tracker_flutter/models/upcoming_expense_model.dart';
import 'package:expense_tracker_flutter/snackbar/snackbar.dart';
import 'package:uuid/uuid.dart';

class UpcomingExpenseHelper {
  UpcomingExpenseHelper._();

  static Stream<List<UpcomingExpense>> getUpcomingExpensesStream() {
    return FirebaseQueryHelper.firebaseFireStore
        .collection(FirebaseConstants.upcomingExpensesCollection)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        final expense = UpcomingExpense.fromMap(data, doc.id);
        expense.docId = doc.id;
        return expense;
      }).toList();

      items.sort((a, b) {
        final aDate = DateTime.tryParse(a.createdAt) ?? DateTime.now();
        final bDate = DateTime.tryParse(b.createdAt) ?? DateTime.now();
        return bDate.compareTo(aDate);
      });

      return items;
    });
  }

  static Future<void> createUpcomingExpense(UpcomingExpense expense) async {
    try {
      await FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.upcomingExpensesCollection)
          .add(expense.toMap());
      showSnackBar(
        message: 'Upcoming note added successfully!',
        type: SnackBarTypes.Success,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        message: e.message ?? 'Failed to add upcoming note',
        type: SnackBarTypes.Error,
      );
    }
  }

  static Future<void> updateUpcomingExpense({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.upcomingExpensesCollection)
          .doc(docId)
          .update(data);
      showSnackBar(
        message: 'Upcoming note updated successfully!',
        type: SnackBarTypes.Success,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        message: e.message ?? 'Failed to update note',
        type: SnackBarTypes.Error,
      );
    }
  }

  static Future<void> deleteUpcomingExpense(String docId) async {
    try {
      await FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.upcomingExpensesCollection)
          .doc(docId)
          .delete();
      showSnackBar(
        message: 'Upcoming note deleted',
        type: SnackBarTypes.Success,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        message: e.message ?? 'Failed to delete note',
        type: SnackBarTypes.Error,
      );
    }
  }

  static Future<void> completeUpcomingExpense({
    required UpcomingExpense upcomingExpense,
    int? customAmount,
  }) async {
    try {
      // 1. Fetch current balance
      final balanceDoc = await FirebaseQueryHelper.getSingleDocumentAsFuture(
        collectionPath: FirebaseConstants.balanceCollection,
        docID: FirebaseConstants.balanceDocID,
      );
      final balanceData = balanceDoc?.data();
      final cashAmount = balanceData?['cash']?.toString() ?? '0';
      final bankAmount = balanceData?['bank']?.toString() ?? '0';

      final finalAmount = customAmount ?? upcomingExpense.amount;
      final now = DateTime.now().toIso8601String();

      // 2. Create the actual Expense in Firestore
      final expense = Expense(
        id: const Uuid().v4(),
        name: upcomingExpense.name,
        category: upcomingExpense.category,
        createAt: now,
        updatedAt: now,
        amount: finalAmount,
        isCash: upcomingExpense.isCash,
      );

      await ExpenseQueryHelper.createExpense(expense, cashAmount, bankAmount);

      // 3. Delete the upcoming note
      if (upcomingExpense.docId != null && upcomingExpense.docId!.isNotEmpty) {
        await FirebaseQueryHelper.firebaseFireStore
            .collection(FirebaseConstants.upcomingExpensesCollection)
            .doc(upcomingExpense.docId)
            .delete();
      }

      showSnackBar(
        message: 'Expense recorded & note completed!',
        type: SnackBarTypes.Success,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        message: e.message ?? 'Failed to complete expense note',
        type: SnackBarTypes.Error,
      );
    } catch (e) {
      showSnackBar(
        message: 'An error occurred while completing expense',
        type: SnackBarTypes.Error,
      );
    }
  }

  static Future<void> clearAllUpcomingExpenses() async {
    try {
      final collectionRef = FirebaseQueryHelper.firebaseFireStore
          .collection(FirebaseConstants.upcomingExpensesCollection);

      final snapshot = await collectionRef.get();
      if (snapshot.docs.isEmpty) {
        showSnackBar(
          message: 'No upcoming notes to clear',
          type: SnackBarTypes.Info,
        );
        return;
      }

      final batch = FirebaseQueryHelper.firebaseFireStore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      showSnackBar(
        message: 'All upcoming notes cleared!',
        type: SnackBarTypes.Success,
      );
    } on FirebaseException catch (e) {
      showSnackBar(
        message: e.message ?? 'Failed to clear notes',
        type: SnackBarTypes.Error,
      );
    }
  }
}
