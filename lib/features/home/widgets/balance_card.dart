import 'package:expense_tracker_flutter/extension/date_extension.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/filter/pages/filter_screen.dart';
import 'package:expense_tracker_flutter/features/home/screen/home_screen.dart';
import 'package:expense_tracker_flutter/features/home/widgets/balance_update_dialog.dart';
import 'package:expense_tracker_flutter/features/home/widgets/category_expense.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/app_color.dart';
import '../../../models/expense_model.dart';

class BalanceCard extends ConsumerStatefulWidget {
  final BehaviorSubject<List<Expense>> sortedExpenseSubject;
  const BalanceCard({
    super.key,
    required this.sortedExpenseSubject,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<BalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
                image: sp.Svg("assets/images/header_background.svg")),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff849D9B).withOpacity(0.78),
                spreadRadius: -7,
                offset: const Offset(0, 10),
                blurRadius: 13.4,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Remaining Balance",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              10.hGap,
              StreamBuilder(
                  stream: FirebaseQueryHelper.getSingleDocumentAsStream(
                      collectionPath: "balance", docID: "G0sKt8y5dvwNsTv63m2f"),
                  builder: (context, snapshot) {
                    final balance = snapshot.data?.data();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Cash",
                              style: TextStyle(
                                color: Color(0xffD0E5E4),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rs ${int.tryParse(balance?['cash'] ?? "").toCurrency}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                4.wGap,
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BalanceUpdateDialog(
                                            isCash: true,
                                            docId: "G0sKt8y5dvwNsTv63m2f",
                                            cashAmount: balance?['cash'],
                                            bankAmount: balance?['bank'],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Bank",
                              style: TextStyle(
                                color: Color(0xffD0E5E4),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rs ${int.tryParse(balance?['bank'] ?? "").toCurrency}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                4.wGap,
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BalanceUpdateDialog(
                                            isCash: false,
                                            docId: "G0sKt8y5dvwNsTv63m2f",
                                            cashAmount: balance?['cash'],
                                            bankAmount: balance?['bank'],
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ))
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  }),
              25.hGap,
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: SvgPicture.asset("assets/images/up_arrow.svg"),
                  ),
                  8.wGap,
                  const Text(
                    "Today's Total Expense",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffD0E5E4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              8.hGap,
              StreamBuilder(
                  stream: widget.sortedExpenseSubject,
                  builder: (context, snapshot) {
                    List<Expense>? expenses = snapshot.data?.where(
                      (element) {
                        final expenseDate = DateTime.parse(element.createAt);
                        return expenseDate.isSameDateAs(DateTime.now());
                      },
                    ).toList();
                    return Text(
                      "Rs ${expenses?.map(
                            (e) => e.amount,
                          ).sum().toCurrency}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
