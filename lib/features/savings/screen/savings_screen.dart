import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/savings/widgets/add_saving_dialog.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:expense_tracker_flutter/models/savings_goal_model.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:shared_preferences/shared_preferences.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class UpdateSavingsDialog extends StatefulWidget {
  final String currentAmount;
  const UpdateSavingsDialog({super.key, required this.currentAmount});

  @override
  State<UpdateSavingsDialog> createState() => _UpdateSavingsDialogState();
}

class _UpdateSavingsDialogState extends State<UpdateSavingsDialog> {
  late final TextEditingController amountController;

  @override
  void initState() {
    amountController = TextEditingController(text: widget.currentAmount);
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomInputDialog(
      title: "Update Total Savings",
      primaryButtonText: "Update",
      onPrimaryPressed: () {
        final newText = amountController.text.trim();
        if (newText.isNotEmpty) {
          FirebaseQueryHelper.updateDocumentOfCollection(
            data: {"amount": newText},
            collectionID: FirebaseConstants.savingsCollection,
            docID: FirebaseConstants.savingsDocID,
          );
          Navigator.pop(context);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Savings Balance",
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          8.hGap,
          TextFormField(
            autofocus: true,
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: CustomInputDecoration.inputDecoration(
              hintText: "E.g. 72938.06",
              prefixIcon: const Icon(Icons.currency_rupee, size: 20),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsScreenState extends State<SavingsScreen> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isObscured = prefs.getBool('is_savings_obscured') ?? true;
      });
    }
  }

  Future<void> _toggleObscured() async {
    HapticFeedback.selectionClick();
    final newValue = !_isObscured;
    setState(() {
      _isObscured = newValue;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_savings_obscured', newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Total Savings",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.selectionClick();
          showDialog(
            context: context,
            builder: (context) => const AddSavingDialog(),
          );
        },
        backgroundColor: AppColor.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Saving",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseQueryHelper.getSingleDocumentAsStream(
          collectionPath: FirebaseConstants.savingsCollection,
          docID: FirebaseConstants.savingsDocID,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final savingsData = snapshot.data?.data();
          final rawAmount = savingsData?['amount']?.toString() ?? "0";
          final amountVal = double.tryParse(rawAmount) ?? 0.0;
          final formattedAmount =
              amountVal == amountVal.toInt()
                  ? amountVal.toInt().toCurrency
                  : rawAmount;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Savings Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff00897B),
                        Color(0xff004D40),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: sp.Svg("assets/images/header_background.svg"),
                      opacity: 0.12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff004D40).withValues(alpha: 0.3),
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
                            "Total Savings",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffB2DFDB),
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
                              Icons.savings_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      8.hGap,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: _toggleObscured,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _isObscured
                                        ? "Rs xxx"
                                        : "Rs $formattedAmount",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  10.wGap,
                                  Icon(
                                    _isObscured
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: Colors.white70,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => UpdateSavingsDialog(
                                      currentAmount: rawAmount,
                                    ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                24.hGap,

                // Savings Goals Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SAVINGS GOALS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _showAddGoalDialog(context);
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        "New Goal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                12.hGap,

                // Savings Goals Stream List
                StreamBuilder(
                  stream: FirebaseQueryHelper.getCollectionAsStream(
                    collectionPath: FirebaseConstants.savingsGoalsCollection,
                  ),
                  builder: (context, goalsSnapshot) {
                    if (!goalsSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = goalsSnapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xff1E293B)
                              : const Color(0xffF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xff334155)
                                : const Color(0xffE2E8F0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 40,
                              color: isDark ? Colors.grey[500] : Colors.grey[400],
                            ),
                            8.hGap,
                            Text(
                              "No savings goals yet",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            4.hGap,
                            Text(
                              "Set target goals for your dream purchases or savings targets.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      separatorBuilder: (context, index) => 12.hGap,
                      itemBuilder: (context, index) {
                        final goalData = docs[index].data();
                        final goal = SavingsGoal.fromJson(
                          goalData,
                          docs[index].id,
                        );

                        final progress = goal.targetAmount > 0
                            ? (goal.currentAmount / goal.targetAmount)
                            : 0.0;
                        final percentage = (progress * 100).toStringAsFixed(1);
                        final isCompleted = goal.currentAmount >= goal.targetAmount;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xff1E293B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCompleted
                                  ? Colors.teal
                                  : isDark
                                      ? const Color(0xff334155)
                                      : const Color(0xffF1F5F9),
                              width: isCompleted ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: isDark ? 0.25 : 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? Colors.teal.withValues(alpha: 0.15)
                                          : AppColor.primary
                                              .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getGoalIcon(goal.category),
                                      color: isCompleted
                                          ? Colors.teal
                                          : AppColor.primary,
                                      size: 22,
                                    ),
                                  ),
                                  12.wGap,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        2.hGap,
                                        Text(
                                          "Goal: Rs ${goal.targetAmount.toInt().toCurrency}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? Colors.teal.withValues(alpha: 0.15)
                                          : Colors.grey.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isCompleted ? "COMPLETED 🎉" : "$percentage%",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isCompleted
                                            ? Colors.teal
                                            : isDark
                                                ? Colors.white70
                                                : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 20,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      FirebaseQueryHelper
                                          .deleteDocumentOfCollection(
                                        collectionID:
                                            FirebaseConstants.savingsGoalsCollection,
                                        docID: goal.id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              12.hGap,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progress.clamp(0.0, 1.0),
                                  minHeight: 8,
                                  backgroundColor: isDark
                                      ? const Color(0xff334155)
                                      : const Color(0xffE2E8F0),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isCompleted ? Colors.teal : AppColor.primary,
                                  ),
                                ),
                              ),
                              10.hGap,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Saved: Rs ${goal.currentAmount.toInt().toCurrency}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _showDepositDialog(
                                        context,
                                        goal,
                                        rawAmount,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.primary
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 14,
                                            color: AppColor.primary,
                                          ),
                                          4.wGap,
                                          Text(
                                            "Deposit",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                40.hGap,
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getGoalIcon(String category) {
    switch (category.toLowerCase()) {
      case 'gadget':
        return Icons.devices_rounded;
      case 'vehicle':
        return Icons.two_wheeler_rounded;
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'emergency':
        return Icons.health_and_safety_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'education':
        return Icons.school_rounded;
      default:
        return Icons.savings_rounded;
    }
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final initialController = TextEditingController(text: "0");
    String selectedCategory = "Gadget";

    final categories = [
      "Gadget",
      "Vehicle",
      "Travel",
      "Emergency",
      "Home",
      "Education",
      "Other",
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return CustomInputDialog(
              title: "Create Savings Goal",
              primaryButtonText: "Create Goal",
              onPrimaryPressed: () {
                final title = titleController.text.trim();
                final target = double.tryParse(targetController.text.trim()) ?? 0.0;
                final initial = double.tryParse(initialController.text.trim()) ?? 0.0;

                if (title.isNotEmpty && target > 0) {
                  final docRef = FirebaseQueryHelper.firebaseFireStore
                      .collection(FirebaseConstants.savingsGoalsCollection)
                      .doc();

                  docRef.set({
                    'id': docRef.id,
                    'title': title,
                    'targetAmount': target,
                    'currentAmount': initial,
                    'category': selectedCategory,
                    'createdAt': DateTime.now().toIso8601String(),
                  });

                  Navigator.pop(context);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Goal Title",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.hGap,
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: CustomInputDecoration.inputDecoration(
                      hintText: "E.g. New iPhone 16 Pro",
                      prefixIcon: const Icon(Icons.flag_rounded, size: 20),
                      isDark: isDark,
                    ),
                  ),
                  12.hGap,
                  Text(
                    "Target Amount",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.hGap,
                  TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: CustomInputDecoration.inputDecoration(
                      hintText: "E.g. 150000",
                      prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                      isDark: isDark,
                    ),
                  ),
                  12.hGap,
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.hGap,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : const Color(0xffF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xff1E293B) : Colors.white,
                        items: categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedCategory = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDepositDialog(
    BuildContext context,
    SavingsGoal goal,
    String totalSavingsRaw,
  ) {
    final depositController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return CustomInputDialog(
          title: "Deposit to ${goal.title}",
          primaryButtonText: "Deposit",
          onPrimaryPressed: () {
            final depositVal =
                double.tryParse(depositController.text.trim()) ?? 0.0;
            if (depositVal > 0) {
              final newGoalAmount = goal.currentAmount + depositVal;

              // Update goal current amount
              FirebaseQueryHelper.firebaseFireStore
                  .collection(FirebaseConstants.savingsGoalsCollection)
                  .doc(goal.id)
                  .update({'currentAmount': newGoalAmount});

              // Also add deposit amount to overall total savings balance
              final currentTotalSavings =
                  double.tryParse(totalSavingsRaw) ?? 0.0;
              final newTotalSavings = currentTotalSavings + depositVal;

              FirebaseQueryHelper.updateDocumentOfCollection(
                data: {"amount": newTotalSavings.toStringAsFixed(2)},
                collectionID: FirebaseConstants.savingsCollection,
                docID: FirebaseConstants.savingsDocID,
              );

              Navigator.pop(context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deposit Amount",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.hGap,
              TextField(
                controller: depositController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: CustomInputDecoration.inputDecoration(
                  hintText: "E.g. 5000",
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
}
