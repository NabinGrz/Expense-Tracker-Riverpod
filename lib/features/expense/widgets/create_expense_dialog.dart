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

        // return Material(
        //   color: Colors.transparent,
        //   child: Container(
        //     padding: const EdgeInsets.all(24),
        //     decoration: const BoxDecoration(
        //       color: Color(0xfff7f6f2),
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20),
        //         topRight: Radius.circular(20),
        //       ),
        //     ),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             const Text("Add Expense"),
        //             IconButton(onPressed: () {}, icon: const Icon(Icons.close))
        //           ],
        //         ),
        //         const Text("Amount"),
        //         const Text("Rs 0"),
        //         const Text("What for?",
        //             style: TextStyle(
        //               // color: Color(0xffeeece8),
        //               fontSize: 14,
        //             )),
        //         TextFormField(
        //           autofocus: true,
        //           controller: expenseNameController,
        //           keyboardType: TextInputType.name,
        //           onChanged: (value) {
        //             // controller.nameError.add(null);
        //           },
        //           style: const TextStyle(fontSize: 14),
        //           decoration: InputDecoration(
        //             contentPadding:
        //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        //             hintText: "Enter expense name...",
        //             hintStyle: const TextStyle(
        //               color: Color(0xff888888),
        //               fontSize: 12,
        //             ),
        //             border: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(8),
        //             ),
        //           ),
        //         ),
        //         const Text("Category",
        //             style: TextStyle(
        //               // color: Color(0xffeeece8),
        //               fontSize: 12,
        //             )),
        //         SingleChildScrollView(
        //           scrollDirection: Axis.horizontal,
        //           child: StreamBuilder(
        //               stream: ExpenseQueryHelper.getExpenseCategory(),
        //               builder: (context, snapshot) {
        //                 final categories = snapshot.data?.docs.first
        //                     .data()['expense_type'] as List?;
        //                 return Row(
        //                   spacing: 12,
        //                   children: categories
        //                           ?.map(
        //                             (e) => Container(
        //                               padding: const EdgeInsets.symmetric(
        //                                   horizontal: 4, vertical: 12),
        //                               decoration: BoxDecoration(
        //                                 color: const Color(0xffe0e0e0),
        //                                 borderRadius: BorderRadius.circular(22),
        //                               ),
        //                               width: 50,
        //                               child: Column(
        //                                 mainAxisSize: MainAxisSize.min,
        //                                 children: [
        //                                   Image.asset(
        //                                     e.toString().getIconPathByCategory,
        //                                     fit: BoxFit.contain,
        //                                     height: 30,
        //                                     width: 30,
        //                                   ),
        //                                   8.hGap,
        //                                   Text(
        //                                     e,
        //                                     overflow: TextOverflow.ellipsis,
        //                                     style: const TextStyle(fontSize: 12),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           )
        //                           .toList() ??
        //                       [],
        //                 );
        //               }),
        //         ),
        //         const Text("Paid with"),
        //         Row(
        //           children: [
        //             PaidWithButton(
        //               isSelected: false,
        //               title: "Cash",
        //               iconPath: "assets/images/dollar.png",
        //               onTap: () {},
        //             ),
        //             16.wGap,
        //             PaidWithButton(
        //               isSelected: false,
        //               title: "Bank",
        //               iconPath: "assets/images/bank.png",
        //               onTap: () {},
        //             ),
        //           ],
        //         ),
        //         26.wGap,
        //         ElevatedButton(
        //             onPressed: () {}, child: const Text("Add Expense")),
        //       ],
        //     ),
        //   ),
        // );

        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Expense Name",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
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
                  },
                ),
                20.hGap,
                const Text(
                  "Amount",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
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
                  },
                ),
                20.hGap,
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                4.hGap,
                StreamBuilder(
                  stream: ExpenseQueryHelper.getExpenseCategory(),
                  builder: (context, snapshot) {
                    final categories =
                        snapshot.data?.docs.first.data()['expense_type']
                            as List?;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff888888)),
                      ),
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
                          initialValue: watch.expenseEntity?.category,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          icon: SvgPicture.asset(
                            "assets/images/down_arrow.svg",
                          ),
                          items: categories?.map((e) {
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
                                  Text(
                                    e,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
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
                    return !snapshot.hasData
                        ? const SizedBox.shrink()
                        : Text(
                            "${snapshot.data}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xffF95B51),
                            ),
                          );
                  },
                ),
                4.hGap,
                Consumer(
                  builder: (context, ref, _) {
                    return Row(
                      children: [
                        const Text(
                          "Is Cash",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox.adaptive(
                          value: watch.expenseEntity?.isCash ?? false,
                          onChanged: (val) {
                            setState(() {
                              controller.updateIsCash(val!);
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                16.hGap,
                Align(
                  alignment: Alignment.center,
                  child: StreamBuilder(
                    stream: FirebaseQueryHelper.getSingleDocumentAsStream(
                      collectionPath: "balance",
                      docID: "G0sKt8y5dvwNsTv63m2f",
                    ),
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
                              amount:
                                  int.tryParse(expenseAmountController.text) ??
                                  0,
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
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PaidWithButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final String title;
  final String iconPath;
  const PaidWithButton({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        // style: ElevatedButton.styleFrom(
        //     minimumSize: const Size(double.infinity, 40)),
        style: ElevatedButton.styleFrom(
          // backgroundColor:
          //     isSelected ? AppColor.primary : const Color(0xffe0e0e0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        icon: Image.asset(iconPath, height: 20, width: 20),
        label: Text(title, style: const TextStyle(fontSize: 12)),
      ),
    );
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/dollar.png", height: 20, width: 20),
            8.wGap,
            const Text("Cash", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
