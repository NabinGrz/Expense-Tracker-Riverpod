import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_entity.dart';
import 'package:expense_tracker_flutter/shared/provider/create_update_expense_provider.dart';
import 'package:expense_tracker_flutter/shared/widgets/custom_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/firebase_query_handler.dart';
import '../../../models/expense_model.dart';

class CreateUpdateDialog extends ConsumerStatefulWidget {
  final bool isUpdate;
  final bool? isCashPreviously;
  final Expense? expenseData;
  final String docId;
  const CreateUpdateDialog({
    super.key,
    this.isUpdate = false,
    this.expenseData,
    required this.docId,
    this.isCashPreviously,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateUpdateDialogState();
}

class _CreateUpdateDialogState extends ConsumerState<CreateUpdateDialog> {
  final expenseNameController = TextEditingController();
  final expenseAmountController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdate) {
      expenseNameController.text = widget.expenseData!.name;
      expenseAmountController.text = widget.expenseData!.amount.toString();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isUpdate) {
        ref
            .read(expenseProvider.notifier)
            .onSelectCategory(widget.expenseData!.category);
        ref
            .read(expenseProvider.notifier)
            .updateIsCash(widget.expenseData!.isCash);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    expenseAmountController.dispose();
    expenseNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final controller = ref.read(expenseProvider.notifier);
        final watch = ref.watch(expenseProvider);

        return CustomInputDialog(
          title: widget.isUpdate ? "Update Expense" : "Add Expense",
          primaryButtonText: widget.isUpdate ? "Update" : "Create",
          onPrimaryPressed: () async {
            // Re-validate and submit
            final stream = FirebaseQueryHelper.getSingleDocumentAsStream(
              collectionPath: FirebaseConstants.balanceCollection,
              docID: FirebaseConstants.balanceDocID,
            );

            Map<String, dynamic>? balance;
            if (stream != null) {
              final balanceSnapshot = await stream.first;
              balance = balanceSnapshot.data();
            }

            if (context.mounted) {
              controller.validateExpenseAndCreate(
                ExpenseEntity(
                  name: expenseNameController.text,
                  amount: int.tryParse(expenseAmountController.text) ?? 0,
                  category: watch.expenseEntity?.category ?? "",
                  isCash: watch.expenseEntity?.isCash,
                ),
                widget.isUpdate,
                widget.docId,
                context,
                cashAmount: balance?['cash'] ?? 0,
                bankAmount: balance?['bank'] ?? 0,
                previousExpenseAmount: widget.expenseData?.amount,
                isCashPreviously: widget.isCashPreviously,
                updatingExpense: widget.expenseData,
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel("Expense Details"),
                8.hGap,
                TextFormField(
                  controller: expenseNameController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: CustomInputDecoration.inputDecoration(
                    hintText: "What was this for?",
                  ),
                  onChanged: (value) => controller.nameError.add(null),
                ),
                StreamBuilder<String?>(
                  stream: controller.nameError,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        "${snapshot.data}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffF95B51),
                        ),
                      ),
                    );
                  },
                ),
                16.hGap,
                _buildLabel("Amount"),
                8.hGap,
                TextFormField(
                  controller: expenseAmountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: CustomInputDecoration.inputDecoration(
                    hintText: "Amount (Rs)",
                    prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                  ),
                  onChanged: (value) => controller.amountError.add(null),
                ),
                StreamBuilder<String?>(
                  stream: controller.amountError,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        "${snapshot.data}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffF95B51),
                        ),
                      ),
                    );
                  },
                ),
                16.hGap,
                _buildLabel("Category"),
                8.hGap,
                StreamBuilder(
                  stream: ExpenseQueryHelper.getExpenseCategory(),
                  builder: (context, snapshot) {
                    final categories =
                        snapshot.data?.docs.first.data()['expense_type']
                            as List?;

                    // Improved Category Selector
                    return Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                        color: const Color(0xffF9FAFB),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          hint: const Text(
                            "Select Category",
                            style: TextStyle(
                              color: Color(0xff9CA3AF),
                              fontSize: 14,
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey,
                          ),
                          initialValue: watch.expenseEntity?.category,
                          items: categories?.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Row(
                                children: [
                                  Image.asset(
                                    e.toString().getIconPathByCategory,
                                    height: 24,
                                    width: 24,
                                  ),
                                  12.wGap,
                                  Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            controller.categoryError.add(null);
                            controller.onSelectCategory(val.toString());
                          },
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder<String?>(
                  stream: controller.categoryError,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        "${snapshot.data}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffF95B51),
                        ),
                      ),
                    );
                  },
                ),
                20.hGap,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: watch.expenseEntity?.isCash == true
                        ? AppColor.primary.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: watch.expenseEntity?.isCash == true
                          ? AppColor.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            watch.expenseEntity?.isCash == true
                                ? Icons.account_balance_wallet
                                : Icons.credit_card,
                            color: watch.expenseEntity?.isCash == true
                                ? AppColor.primary
                                : Colors.grey[600],
                          ),
                          12.wGap,
                          Text(
                            "Paid via Cash",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: watch.expenseEntity?.isCash == true
                                  ? AppColor.primary
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        activeColor: AppColor.primary,
                        value: watch.expenseEntity?.isCash ?? false,
                        onChanged: (val) {
                          setState(() {
                            controller.updateIsCash(val);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey[600],
        letterSpacing: 1.1,
      ),
    );
  }
}
