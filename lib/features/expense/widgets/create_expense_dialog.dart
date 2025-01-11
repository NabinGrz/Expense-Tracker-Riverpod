import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/extension/string_extension.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/models/expense_entity.dart';
import 'package:expense_tracker_flutter/shared/provider/create_update_expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../helper/firebase_query_handler.dart';
import '../../../models/expense_model.dart';

class CreateUpdateDialog extends ConsumerStatefulWidget {
  final bool isUpdate;
  final bool? isCashPreviously;
  final Expense? expenseData;
  final String? docId;
  const CreateUpdateDialog({
    super.key,
    this.isUpdate = false,
    this.expenseData,
    this.docId,
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.isUpdate) {
          ref
              .read(expenseProvider.notifier)
              .onSelectCategory(widget.expenseData!.category);
          ref
              .read(expenseProvider.notifier)
              .updateIsCash(widget.expenseData!.isCash);
        }
      },
    );
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
    return StatefulBuilder(builder: (context, setState) {
      final controller = ref.read(expenseProvider.notifier);
      final watch = ref.watch(expenseProvider);

      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Expense Name",
                style: TextStyle(fontSize: 12),
              ),
              4.hGap,
              TextFormField(
                autofocus: true,
                controller: expenseNameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  controller.nameError.add(null);
                },
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  hintText: "Enter expense name...",
                  hintStyle: const TextStyle(
                    color: Color(0xff888888),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              StreamBuilder<String?>(
                  stream: controller.nameError,
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? const SizedBox.shrink()
                        : Text(
                            "${snapshot.data}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xffF95B51),
                            ),
                          );
                  }),
              20.hGap,
              const Text(
                "Amount",
                style: TextStyle(fontSize: 12),
              ),
              4.hGap,
              TextFormField(
                controller: expenseAmountController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.amountError.add(null);
                },
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  hintText: "Enter expense amount...",
                  hintStyle: const TextStyle(
                    color: Color(0xff888888),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              StreamBuilder<String?>(
                  stream: controller.amountError,
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? const SizedBox.shrink()
                        : Text(
                            "${snapshot.data}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xffF95B51),
                            ),
                          );
                  }),
              20.hGap,
              const Text(
                "Category",
                style: TextStyle(fontSize: 12),
              ),
              4.hGap,
              StreamBuilder(
                stream: ExpenseQueryHelper.getExpenseCategory(),
                builder: (context, snapshot) {
                  final categories =
                      snapshot.data?.docs.first.data()['expense_type'] as List?;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xff888888),
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        hint: watch.expenseEntity?.category == null
                            ? const Text(
                                "Select Category",
                                style: TextStyle(
                                  color: Color(0xff888888),
                                  fontSize: 12,
                                ),
                              )
                            : null,
                        value: watch.expenseEntity?.category,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        icon: SvgPicture.asset("assets/images/down_arrow.svg"),
                        items: categories?.map(
                          (e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      e.toString().getIconPathByCategory,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  4.wGap,
                                  Text(e),
                                ],
                              ),
                            );
                          },
                        ).toList(),
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
                    return !snapshot.hasData
                        ? const SizedBox.shrink()
                        : Text(
                            "${snapshot.data}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xffF95B51),
                            ),
                          );
                  }),
              4.hGap,
              Consumer(builder: (context, ref, _) {
                return Row(
                  children: [
                    const Text(
                      "Is Cash",
                      style: TextStyle(fontSize: 12),
                    ),
                    Checkbox.adaptive(
                        value: watch.expenseEntity?.isCash ?? false,
                        onChanged: (val) {
                          setState(
                            () {
                              controller.updateIsCash(val!);
                            },
                          );
                        }),
                  ],
                );
              }),
              16.hGap,
              Align(
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: FirebaseQueryHelper.getSingleDocumentAsStream(
                        collectionPath: "balance",
                        docID: "G0sKt8y5dvwNsTv63m2f"),
                    builder: (context, snapshot) {
                      final balance = snapshot.data?.data();
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 40),
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          controller.validateExpenseAndCreate(
                            ExpenseEntity(
                                name: expenseNameController.text,
                                amount: int.tryParse(
                                        expenseAmountController.text) ??
                                    0,
                                category: watch.expenseEntity?.category ?? "",
                                isCash: watch.expenseEntity?.isCash),
                            widget.isUpdate,
                            widget.docId,
                            context,
                            cashAmount: balance?['cash'] ?? 0,
                            bankAmount: balance?['bank'] ?? 0,
                            previousExpenseAmount: widget.expenseData?.amount,
                            isCashPreviously: widget.isCashPreviously,
                            updatingExpense: widget.expenseData,
                          );
                        },
                        child: Text(
                          widget.isUpdate ? "Update" : "Create",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }
}
