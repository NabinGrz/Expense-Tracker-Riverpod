import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/features/upcoming_expenses/widgets/add_edit_upcoming_dialog.dart';
import 'package:expense_tracker_flutter/helper/upcoming_expense_helper.dart';
import 'package:expense_tracker_flutter/models/upcoming_expense_model.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;

class UpcomingExpensesScreen extends StatefulWidget {
  const UpcomingExpensesScreen({super.key});

  @override
  State<UpcomingExpensesScreen> createState() => _UpcomingExpensesScreenState();
}

class _UpcomingExpensesScreenState extends State<UpcomingExpensesScreen> {
  void _openAddNoteDialog() {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (context) => const AddEditUpcomingDialog(),
    );
  }

  void _openEditNoteDialog(UpcomingExpense expense) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (context) => AddEditUpcomingDialog(existingExpense: expense),
    );
  }

  void _showCompleteDialog(UpcomingExpense expense) {
    HapticFeedback.selectionClick();
    final amountController =
        TextEditingController(text: expense.amount.toString());

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return CustomInputDialog(
          title: 'Complete Expense',
          primaryButtonText: 'Log & Complete',
          onPrimaryPressed: () async {
            final enteredAmount =
                int.tryParse(amountController.text.trim()) ?? expense.amount;
            Navigator.pop(context);
            await UpcomingExpenseHelper.completeUpcomingExpense(
              upcomingExpense: expense,
              customAmount: enteredAmount,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mark "${expense.name}" as completed?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              6.hGap,
              Text(
                'This will add it to your actual expenses, deduct Rs ${expense.amount} from your ${expense.isCash ? 'Cash' : 'Bank'} balance, and delete this note.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              16.hGap,
              Text(
                'Actual Amount Spent (Rs)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : const Color(0xff4B5563),
                ),
              ),
              8.hGap,
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: CustomInputDecoration.inputDecoration(
                  hintText: 'Amount (Rs)',
                  prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(UpcomingExpense expense) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Delete Note?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "${expense.name}" from upcoming notes without logging it as an expense?',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                final docId = expense.docId ?? expense.id;
                UpcomingExpenseHelper.deleteUpcomingExpense(docId);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearAll() {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).cardColor,
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 24),
              8.wGap,
              Text(
                'Clear All Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to clear all upcoming expense notes? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                UpcomingExpenseHelper.clearAllUpcomingExpenses();
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Upcoming Expenses',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            tooltip: 'Clear All Notes',
            onPressed: _confirmClearAll,
            icon: const Icon(
              Icons.cleaning_services_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddNoteDialog,
        backgroundColor: AppColor.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Note',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<UpcomingExpense>>(
        stream: UpcomingExpenseHelper.getUpcomingExpensesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final upcomingList = snapshot.data ?? [];
          final totalPlanned = upcomingList.fold<int>(
            0,
            (sum, item) => sum + item.amount,
          );

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff4F46E5),
                        Color(0xff312E81),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: sp.Svg('assets/images/header_background.svg'),
                      opacity: 0.12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff312E81).withValues(alpha: 0.35),
                        spreadRadius: -2,
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Planned Expenses',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffC7D2FE),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      6.hGap,
                      Text(
                        'Rs ${totalPlanned.toCurrency}',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      10.hGap,
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${upcomingList.length} planned ${upcomingList.length == 1 ? 'item' : 'items'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          12.wGap,
                          const Text(
                            'Tap checkmark to log & complete',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xffE0E7FF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                24.hGap,

                // Section Title & Clear All row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PLANNED LIST',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    if (upcomingList.isNotEmpty)
                      InkWell(
                        onTap: _confirmClearAll,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_sweep_rounded,
                                size: 16,
                                color: Colors.redAccent,
                              ),
                              4.wGap,
                              const Text(
                                'Clear All',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                12.hGap,

                // List or Empty State
                if (upcomingList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xff1E293B)
                          : const Color(0xffF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xff334155)
                            : const Color(0xffE2E8F0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          size: 48,
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                        ),
                        12.hGap,
                        Text(
                          'No upcoming expenses noted',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        6.hGap,
                        Text(
                          'Jot down what you plan to spend. Mark completed when done to log it automatically!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        20.hGap,
                        ElevatedButton.icon(
                          onPressed: _openAddNoteDialog,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Note'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: upcomingList.length,
                    separatorBuilder: (context, index) => 12.hGap,
                    itemBuilder: (context, index) {
                      final item = upcomingList[index];
                      return _buildUpcomingItemCard(item, isDark);
                    },
                  ),

                80.hGap,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingItemCard(UpcomingExpense item, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xff334155) : const Color(0xffF1F5F9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Complete button (Check circle)
          IconButton(
            tooltip: 'Mark as Completed',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primary,
                  width: 2,
                ),
                color: AppColor.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.check,
                size: 16,
                color: AppColor.primary,
              ),
            ),
            onPressed: () => _showCompleteDialog(item),
          ),

          8.wGap,

          // Category Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff334155) : const Color(0xffF8FAFC),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              item.category.getIconPathByCategory,
              height: 24,
              width: 24,
            ),
          ),

          12.wGap,

          // Details (Title, Note, Category/Payment tag)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xff1E293B),
                  ),
                ),
                if (item.note != null && item.note!.isNotEmpty) ...[
                  2.hGap,
                  Text(
                    item.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
                4.hGap,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item.category.getColorByCategory
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category.capitalize(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.category.getColorByCategory,
                        ),
                      ),
                    ),
                    6.wGap,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item.isCash
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.blue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.isCash ? 'Cash' : 'Bank',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.isCash ? Colors.green : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          8.wGap,

          // Amount and actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs ${item.amount.toCurrency}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              4.hGap,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _openEditNoteDialog(item),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  4.wGap,
                  InkWell(
                    onTap: () => _confirmDelete(item),
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
