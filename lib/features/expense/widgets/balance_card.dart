import 'dart:convert';

import 'package:expense_tracker_flutter/constants/firebase_constants.dart';
import 'package:expense_tracker_flutter/extension/iterable_extension.dart';
import 'package:expense_tracker_flutter/extension/num_extension.dart';
import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/expense/widgets/balance_update_dialog.dart';
import 'package:expense_tracker_flutter/features/settings/controller/settings_controller.dart';
import 'package:expense_tracker_flutter/helper/expense_query_helper.dart';
import 'package:expense_tracker_flutter/helper/firebase_query_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as sp;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _isCashObscured = true;
  bool _isBankObscured = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isCashObscured = prefs.getBool('is_cash_obscured') ?? true;
        _isBankObscured = prefs.getBool('is_bank_obscured') ?? true;
      });
    }
  }

  Future<void> _toggleCashObscured() async {
    HapticFeedback.selectionClick();
    final newValue = !_isCashObscured;
    setState(() {
      _isCashObscured = newValue;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_cash_obscured', newValue);
  }

  Future<void> _toggleBankObscured() async {
    HapticFeedback.selectionClick();
    final newValue = !_isBankObscured;
    setState(() {
      _isBankObscured = newValue;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_bank_obscured', newValue);
  }

  @override
  void dispose() {
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
          margin: const EdgeInsets.only(left: 14, right: 14, top: 16),
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLowBalance
                  ? [const Color(0xffE11D48), const Color(0xffBE123C)]
                  : [const Color(0xff0F766E), const Color(0xff115E59)],
            ),
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: sp.Svg("assets/images/header_background.svg"),
              opacity: 0.1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isLowBalance ? const Color(0xffBE123C) : const Color(0xff115E59))
                    .withValues(alpha: 0.35),
                spreadRadius: -4,
                offset: const Offset(0, 10),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isLowBalance ? "⚠️ Low Balance" : "Remaining balance",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
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
                          InkWell(
                            onTap: _toggleCashObscured,
                            child: Text(
                              _isCashObscured ? "Rs xxx" : "Rs ${cash.toCurrency}",
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
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
                          InkWell(
                            onTap: _toggleBankObscured,
                            child: Text(
                              _isBankObscured ? "Rs xxx" : "Rs ${bank.toCurrency}",
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
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
                    stream: ExpenseQueryHelper.getExpense(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Expanded(child: SizedBox());
                      }
                      final expenses = snapshot.data!.docs.map((doc) {
                        final expense = Expense.fromJson(jsonEncode(doc.data()));
                        expense.docId = doc.id;
                        return expense;
                      }).toList();

                      final billingStartDay =
                          ref
                              .watch(settingsControllerProvider)
                              .value
                              ?.billingStartDay ??
                          7;
                      final cycle = ExpenseUtils.getNepaliBillingCycle(
                        startDay: billingStartDay,
                      );
                      final total =
                          expenses
                              .where((element) {
                                final expenseDateEnglish = DateTime.parse(
                                  element.createAt,
                                );
                                final expenseDateNepali = expenseDateEnglish
                                    .toNepaliDateTime();
                                final isWithinCycle =
                                    expenseDateNepali.compareTo(
                                          cycle.start,
                                        ) >=
                                        0 &&
                                    expenseDateNepali.compareTo(cycle.end) < 0;
                                final category = element.category
                                    .toLowerCase()
                                    .trim();
                                final isSaving =
                                    category == 'saving' ||
                                    category == 'savings';
                                return isWithinCycle && !isSaving;
                              })
                              .map((e) => e.amount)
                              .sum();

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
