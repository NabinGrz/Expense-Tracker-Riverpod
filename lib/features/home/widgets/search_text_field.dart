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
    return TextFormField(
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
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset("assets/images/search.svg"),
        ),
        suffixIcon: InkWell(
          onTap: () {
            controller.sortedExpenseSubject.add(originalExpenseList);
            searchController.clear();
            FocusScope.of(context).unfocus();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.clear),
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        hintText: "Search...",
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w200,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
