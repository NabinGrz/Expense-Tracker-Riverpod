import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: widget.isCash
          ? const Text("Update Cash Amount")
          : const Text("Update Bank Amount"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Amount",
            style: TextStyle(fontSize: 12),
          ),
          8.hGap,
          TextFormField(
            autofocus: true,
            controller:
                widget.isCash ? cashAmountController : bankAmountController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // controller.nameError.add(null);
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              hintText: widget.isCash
                  ? "Enter cash amount..."
                  : "Enter bank amount...",
              hintStyle: const TextStyle(
                color: Color(0xff888888),
                fontSize: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          20.hGap,
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.sizeOf(context).width * 0.5, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // button's shape
                ),
              ),
              onPressed: () {
                if (widget.isCash) {
                  if (cashAmountController.text.isNotEmpty &&
                      cashAmountController.text != "0") {
                    FirebaseQueryHelper.updateDocumentOfCollection(
                        data: {"cash": cashAmountController.text},
                        collectionID: "balance",
                        docID: widget.docId);
                    Navigator.pop(context);
                  }
                } else {
                  if (bankAmountController.text.isNotEmpty &&
                      bankAmountController.text != "0") {
                    FirebaseQueryHelper.updateDocumentOfCollection(
                        data: {"bank": bankAmountController.text},
                        collectionID: "balance",
                        docID: widget.docId);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text(
                "Update",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
