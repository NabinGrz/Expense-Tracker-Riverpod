import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/helper/upcoming_expense_helper.dart';
import 'package:expense_tracker_flutter/models/upcoming_expense_model.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddEditUpcomingDialog extends ConsumerStatefulWidget {
  final UpcomingExpense? existingExpense;

  const AddEditUpcomingDialog({
    super.key,
    this.existingExpense,
  });

  @override
  ConsumerState<AddEditUpcomingDialog> createState() =>
      _AddEditUpcomingDialogState();
}

class _AddEditUpcomingDialogState extends ConsumerState<AddEditUpcomingDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  String _selectedCategory = 'food';
  bool _isCash = true;

  bool get _isEditing => widget.existingExpense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.existingExpense;
    final defaultIsCash = ref.read(settingsControllerProvider).value?.defaultIsCash ?? true;
    _nameController = TextEditingController(text: expense?.name ?? '');
    _amountController = TextEditingController(
      text: expense != null && expense.amount > 0 ? expense.amount.toString() : '',
    );
    _noteController = TextEditingController(text: expense?.note ?? '');
    _selectedCategory = expense?.category ?? 'food';
    _isCash = expense?.isCash ?? defaultIsCash;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    final note = _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null;

    if (_isEditing) {
      final updatedData = {
        'name': name,
        'amount': amount,
        'category': _selectedCategory,
        'isCash': _isCash,
        'note': note,
      };

      UpcomingExpenseHelper.updateUpcomingExpense(
        docId: widget.existingExpense!.docId ?? widget.existingExpense!.id,
        data: updatedData,
      );
    } else {
      final newExpense = UpcomingExpense(
        id: const Uuid().v4(),
        name: name,
        amount: amount,
        category: _selectedCategory,
        isCash: _isCash,
        createdAt: DateTime.now().toIso8601String(),
        note: note,
      );

      UpcomingExpenseHelper.createUpcomingExpense(newExpense);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomInputDialog(
      title: _isEditing ? 'Edit Upcoming Note' : 'Add Upcoming Note',
      primaryButtonText: _isEditing ? 'Save Changes' : 'Add Note',
      onPrimaryPressed: _submit,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLabel('Expense Name / What for?', isDark),
            8.hGap,
            TextFormField(
              controller: _nameController,
              autocorrect: false,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: CustomInputDecoration.inputDecoration(
                hintText: 'E.g. Electricity Bill, Team Lunch',
                isDark: isDark,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name or description';
                }
                return null;
              },
            ),
            16.hGap,
            _buildLabel('Estimated Amount (Rs)', isDark),
            8.hGap,
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: CustomInputDecoration.inputDecoration(
                hintText: 'Amount (Rs)',
                prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                isDark: isDark,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the planned amount';
                }
                final numVal = int.tryParse(value.trim());
                if (numVal == null || numVal <= 0) {
                  return 'Enter a valid positive amount';
                }
                return null;
              },
            ),
            16.hGap,
            _buildLabel('Category', isDark),
            8.hGap,
            StreamBuilder(
              stream: ExpenseQueryHelper.getExpenseCategory(),
              builder: (context, snapshot) {
                final rawCategories = snapshot.data?.docs.firstOrNull?.data()['expense_type'] as List?;
                final categoriesList = rawCategories != null
                    ? List<String>.from(rawCategories.map((e) => e.toString()))
                    : <String>['food', 'grocery', 'bills', 'rent', 'utils', 'personal'];

                if (!categoriesList.contains(_selectedCategory)) {
                  categoriesList.insert(0, _selectedCategory);
                }

                return Container(
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : const Color(0xffE5E7EB),
                    ),
                    color: isDark ? const Color(0xff333333) : const Color(0xffF9FAFB),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      initialValue: _selectedCategory,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                      dropdownColor: theme.cardColor,
                      items: categoriesList.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Image.asset(
                                e.getIconPathByCategory,
                                height: 24,
                                width: 24,
                              ),
                              12.wGap,
                              Text(
                                e.capitalize(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCategory = val;
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            16.hGap,
            _buildLabel('Payment Method', isDark),
            8.hGap,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCash = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isCash
                            ? AppColor.primary.withValues(alpha: 0.12)
                            : (isDark ? const Color(0xff333333) : const Color(0xffF9FAFB)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isCash
                              ? AppColor.primary
                              : (isDark ? Colors.grey[700]! : const Color(0xffE5E7EB)),
                          width: _isCash ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/dollar.png',
                            height: 18,
                            width: 18,
                          ),
                          8.wGap,
                          Text(
                            'Cash',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _isCash
                                  ? AppColor.primary
                                  : (isDark ? Colors.grey[300] : Colors.grey[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                12.wGap,
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCash = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isCash
                            ? AppColor.primary.withValues(alpha: 0.12)
                            : (isDark ? const Color(0xff333333) : const Color(0xffF9FAFB)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: !_isCash
                              ? AppColor.primary
                              : (isDark ? Colors.grey[700]! : const Color(0xffE5E7EB)),
                          width: !_isCash ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_rounded,
                            size: 18,
                            color: !_isCash
                                ? AppColor.primary
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          ),
                          8.wGap,
                          Text(
                            'Bank',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: !_isCash
                                  ? AppColor.primary
                                  : (isDark ? Colors.grey[300] : Colors.grey[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            16.hGap,
            _buildLabel('Optional Note / Remarks', isDark),
            8.hGap,
            TextFormField(
              controller: _noteController,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontWeight: FontWeight.w500),
              decoration: CustomInputDecoration.inputDecoration(
                hintText: 'e.g. Split with John',
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[300] : const Color(0xff4B5563),
      ),
    );
  }
}
