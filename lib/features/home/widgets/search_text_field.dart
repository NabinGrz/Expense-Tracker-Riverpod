import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/expense_model.dart';
import '../entity/home_entity.dart';
import '../provider/home_provider.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.searchController,
    required this.homeEntity,
    required this.controller,
    required this.originalExpenseList,
  });

  final TextEditingController searchController;
  final HomeEntity homeEntity;
  final HomeNotifier controller;
  final List<Expense> originalExpenseList;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: searchController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          final searchedExpenses = homeEntity.expenses?.where(
            (element) {
              return element.name.toLowerCase().contains(value.toLowerCase()) ||
                  element.category.toLowerCase().contains(value.toLowerCase());
            },
          ).toList();
          controller.sortedExpenseSubject.add(searchedExpenses ?? []);
        } else {
          controller.sortedExpenseSubject.add(originalExpenseList);
        }
      },
      onSuffixTap: () {
        controller.sortedExpenseSubject.add(originalExpenseList);
        searchController.clear();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
