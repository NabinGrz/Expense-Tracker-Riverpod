import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/expense/widgets/balance_update_dialog.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/expense_model.dart';
import '../../../utils/expense_utils.dart';

class BalanceCard extends ConsumerStatefulWidget {
  final BehaviorSubject<List<Expense>> sortedExpenseSubject;
  const BalanceCard({super.key, required this.sortedExpenseSubject});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<BalanceCard>
    with SingleTickerProviderStateMixin {
  NepaliDateTime nepaliNow = NepaliDateTime.now();
  DateTime englishNow = DateTime.now();
  // int lastday = NepaliDateTime(now.year, now.month + 1, 0).day;

  // late AnimationController animationController;
  // late Animation<double> animation;
  @override
  void initState() {
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 500),
    // );

    // final curvedAnimation = CurvedAnimation(
    //   parent: animationController,
    //   curve: Curves.fastOutSlowIn,
    // );
    // animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    // animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseQueryHelper.getSingleDocumentAsStream(
        collectionPath: FirebaseConstants.balanceCollection,
        docID: FirebaseConstants.balanceDocID,
      ),
      builder: (context, snapshot) {
        final balance = snapshot.data?.data();
        final cash = int.tryParse(balance?['cash'] ?? "") ?? 0;
        final bank = int.tryParse(balance?['bank'] ?? "") ?? 0;
        final totalBalance = cash + bank;
        final isLowBalance = totalBalance <= 20000;

        return Container(
          margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLowBalance
                  ? [const Color(0xffD32F2F), const Color(0xffEF5350)]
                  : [AppColor.primary, AppColor.test],
            ),
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: sp.Svg("assets/images/header_background.svg"),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff849D9B).withOpacity(0.78),
                spreadRadius: -7,
                offset: const Offset(0, 10),
                blurRadius: 13.4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLowBalance ? "⚠️ Low Balance" : "Remaining this month",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              10.hGap,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Cash",
                        style: TextStyle(color: Color(0xffD0E5E4)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Rs ${cash.toCurrency}",
                            style: const TextStyle(
                              fontSize: 20,
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
                                    docId: FirebaseConstants.balanceDocID,
                                    cashAmount: balance?['cash'],
                                    bankAmount: balance?['bank'],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bank",
                        style: TextStyle(color: Color(0xffD0E5E4)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Rs ${bank.toCurrency}",
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontSize: 20,
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
                                    docId: FirebaseConstants.balanceDocID,
                                    cashAmount: balance?['cash'],
                                    bankAmount: balance?['bank'],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              25.hGap,
              //f6f6f6
              const Divider(color: Color(0xffe5e7eb), thickness: 1),
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
                  StreamBuilder(
                    stream: widget.sortedExpenseSubject,
                    builder: (context, snapshot) {
                      final billingStartDay =
                          ref.watch(settingsControllerProvider).value ?? 7;
                      final cycle = ExpenseUtils.getNepaliBillingCycle(
                        startDay: billingStartDay,
                      );
                      final total =
                          snapshot.data
                              ?.where((element) {
                                final expenseDateEnglish = DateTime.parse(
                                  element.createAt,
                                );
                                final expenseDateNepali = expenseDateEnglish
                                    .toNepaliDateTime();
                                return expenseDateNepali.compareTo(
                                          cycle.start,
                                        ) >=
                                        0 &&
                                    expenseDateNepali.compareTo(cycle.end) < 0;
                              })
                              .map((e) => e.amount)
                              .sum() ??
                          0;

                      return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${NepaliDateFormat('MMMM').format(cycle.start)}'s Expense",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xffD0E5E4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Rs ${total.toCurrency}",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              8.hGap,
            ],
          ),
        );
      },
    );
  }
}
