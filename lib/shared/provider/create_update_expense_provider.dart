import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_entity.dart';
import 'package:expense_tracker_flutter/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

final expenseProvider = ChangeNotifierProvider.autoDispose<ExpenseNotifier>(
  (ref) => ExpenseNotifier(),
);

class ExpenseNotifier extends ChangeNotifier {
  final nameError = BehaviorSubject<String?>();
  final amountError = BehaviorSubject<String?>();
  final categoryError = BehaviorSubject<String?>();

  ExpenseEntity? expenseEntity = ExpenseEntity.initial();

  void onSelectCategory(String name) {
    expenseEntity = expenseEntity?.copyWith(category: name);
    notifyListeners();
  }

  void updateIsCash(bool val) {
    expenseEntity = expenseEntity?.copyWith(isCash: val);
    notifyListeners();
    expenseEntity;
  }

  void addUpdateExpense(
    ExpenseEntity expense,
    bool isUpdate, {
    String? docId,
    required String cashAmount,
    required String bankAmount,
    int? previousExpenseAmount,
    bool? isCashPreviously,
  }) {
    final expenseData = Expense(
        id: const Uuid().v4(),
        name: expense.name!,
        category: expenseEntity!.category!,
        createAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        amount: expense.amount!,
        isCash: expenseEntity?.isCash ?? false);
    if (isUpdate) {
      if (isCashPreviously == expense.isCash) {
        ExpenseQueryHelper.updateExpense(expenseData.toMap(), docId!,
            cashAmount, bankAmount, previousExpenseAmount);
      } else {
        ExpenseQueryHelper.updateExpenseAmounWhenTypeChange(
            newData: expenseData.toMap(),
            id: docId!,
            isCash: expense.isCash ?? false,
            oldAmount: previousExpenseAmount!.toString(),
            newAmount: expense.amount!.toString(),
            cashAmount: cashAmount,
            bankAmount: bankAmount);
      }
    } else {
      ExpenseQueryHelper.createExpense(expenseData, cashAmount, bankAmount);
    }
  }

  void validateExpenseAndCreate(
    ExpenseEntity expenseData,
    bool isUpdate,
    String? docId,
    BuildContext context, {
    required String cashAmount,
    required String bankAmount,
    int? previousExpenseAmount,
    bool? isCashPreviously,
  }) {
    bool validName = expenseData.name.isNotNullAndEmpty;
    bool validAmount = (expenseData.amount != 0 && expenseData.amount != null);
    bool validCategory = expenseData.category.isNotNullAndEmpty;
    if (validName &&
        validAmount &&
        validCategory &&
        expenseData.isCash != null) {
      addUpdateExpense(expenseData, isUpdate,
          docId: docId,
          cashAmount: cashAmount,
          bankAmount: bankAmount,
          previousExpenseAmount: previousExpenseAmount,
          isCashPreviously: isCashPreviously);
      Navigator.pop(context);
    } else {
      if (!validName) {
        nameError.add("Required");
      }
      if (!validAmount) {
        amountError.add("Required");
      }
      if (!validCategory) {
        categoryError.add("Required");
      }
    }
  }
}
