import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _onSearchChanged(String value) {
    if (value.trim().isNotEmpty) {
      final query = value.trim().toLowerCase();
      final searchedExpenses = originalExpenseList.where((element) {
        final nameMatch = element.name.toLowerCase().contains(query);
        final categoryMatch = element.category.toLowerCase().contains(query);
        return nameMatch || categoryMatch;
      }).toList();
      controller.sortedExpenseSubject.add(searchedExpenses);
    } else {
      controller.sortedExpenseSubject.add(originalExpenseList);
    }
  }

  void _clearSearch() {
    HapticFeedback.selectionClick();
    searchController.clear();
    controller.sortedExpenseSubject.add(originalExpenseList);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, child) {
        final hasText = value.text.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff1E293B) : const Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? (hasText ? const Color(0xff3B82F6) : const Color(0xff334155))
                  : (hasText ? const Color(0xff2563EB) : const Color(0xffE2E8F0)),
              width: hasText ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: _onSearchChanged,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xff1E293B),
            ),
            decoration: InputDecoration(
              hintText: "Search title or category...",
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xff64748B) : const Color(0xff94A3B8),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: isDark
                      ? (hasText ? const Color(0xff60A5FA) : const Color(0xff64748B))
                      : (hasText ? const Color(0xff2563EB) : const Color(0xff94A3B8)),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              suffixIcon: hasText
                  ? InkWell(
                      onTap: _clearSearch,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xff334155)
                                : const Color(0xffE2E8F0),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: isDark
                                ? const Color(0xff94A3B8)
                                : const Color(0xff64748B),
                          ),
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
