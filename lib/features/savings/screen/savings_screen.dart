import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/savings/widgets/add_saving_dialog.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
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

          return Padding(
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
                        color: const Color(0xff004D40).withOpacity(0.3),
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
                              color: Colors.white.withOpacity(0.15),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
