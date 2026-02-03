import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:flutter/material.dart';

import '../../../constants/firebase_constants.dart';

class BalanceUpdateDialog extends StatefulWidget {
  final String docId;
  final String cashAmount;
  final String bankAmount;
  final bool isCash;
  const BalanceUpdateDialog({
    super.key,
    required this.docId,
    required this.isCash,
    required this.cashAmount,
    required this.bankAmount,
  });

  @override
  State<BalanceUpdateDialog> createState() => _BalanceUpdateDialogState();
}

class _BalanceUpdateDialogState extends State<BalanceUpdateDialog> {
  final bankAmountController = TextEditingController();
  final cashAmountController = TextEditingController();

  @override
  void dispose() {
    bankAmountController.dispose();
    cashAmountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    bankAmountController.text = widget.bankAmount;
    cashAmountController.text = widget.cashAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomInputDialog(
      title: "Update ${widget.isCash ? "Cash" : "Bank"} Amount",
      primaryButtonText: "Update",
      onPrimaryPressed: () {
        if (widget.isCash) {
          if (cashAmountController.text.isNotEmpty &&
              cashAmountController.text != "0") {
            FirebaseQueryHelper.updateDocumentOfCollection(
              data: {"cash": cashAmountController.text},
              collectionID: FirebaseConstants.balanceCollection,
              docID: widget.docId,
            );
            Navigator.pop(context);
          }
        } else {
          if (bankAmountController.text.isNotEmpty &&
              bankAmountController.text != "0") {
            FirebaseQueryHelper.updateDocumentOfCollection(
              data: {"bank": bankAmountController.text},
              collectionID: FirebaseConstants.balanceCollection,
              docID: widget.docId,
            );
            Navigator.pop(context);
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isCash ? "Total Cash on Hand" : "Total Bank Balance",
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          8.hGap,
          TextFormField(
            autofocus: true,
            controller: widget.isCash
                ? cashAmountController
                : bankAmountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: CustomInputDecoration.inputDecoration(
              hintText: widget.isCash ? "E.g. 5000" : "E.g. 150000",
              prefixIcon: const Icon(Icons.currency_rupee, size: 20),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}
