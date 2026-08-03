import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:flutter/material.dart';

class AddSavingDialog extends StatefulWidget {
  const AddSavingDialog({super.key});

  @override
  State<AddSavingDialog> createState() => _AddSavingDialogState();
}

class _AddSavingDialogState extends State<AddSavingDialog> {
  final amountController = TextEditingController();
  bool isLoading = false;
  String? amountError;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amountText = amountController.text.trim();
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() {
        amountError = "Please enter a valid amount";
      });
      return;
    }

    setState(() {
      isLoading = true;
      amountError = null;
    });

    try {
      final savingsStream = FirebaseQueryHelper.getSingleDocumentAsStream(
        collectionPath: FirebaseConstants.savingsCollection,
        docID: FirebaseConstants.savingsDocID,
      );

      if (savingsStream != null) {
        final savingsSnapshot = await savingsStream.first;
        final currentSavingsStr =
            savingsSnapshot.data()?['amount']?.toString() ?? "0";
        final currentSavings = double.tryParse(currentSavingsStr) ?? 0.0;
        final newSavings = currentSavings + amount;

        final formattedNewSavings =
            newSavings == newSavings.toInt()
                ? newSavings.toInt().toString()
                : newSavings.toStringAsFixed(2);

        FirebaseQueryHelper.updateDocumentOfCollection(
          data: {"amount": formattedNewSavings},
          collectionID: FirebaseConstants.savingsCollection,
          docID: FirebaseConstants.savingsDocID,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          amountError = "Failed to add saving";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomInputDialog(
      title: "Add Saving",
      primaryButtonText: isLoading ? "Adding..." : "Add",
      isPrimaryButtonEnabled: !isLoading,
      onPrimaryPressed: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Amount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : const Color(0xff374151),
            ),
          ),
          8.hGap,
          TextFormField(
            autofocus: true,
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: CustomInputDecoration.inputDecoration(
              hintText: "Enter amount (Rs)",
              prefixIcon: const Icon(Icons.currency_rupee, size: 20),
              isDark: isDark,
            ),
            onChanged: (_) {
              if (amountError != null) {
                setState(() => amountError = null);
              }
            },
          ),
          if (amountError != null) ...[
            4.hGap,
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                amountError!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xffF95B51),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
