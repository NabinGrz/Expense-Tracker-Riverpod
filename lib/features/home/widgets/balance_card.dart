import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_color.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 145),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff849D9B).withOpacity(0.78),
              spreadRadius: -7,
              offset: const Offset(0, 10),
              blurRadius: 13.4,
            )
          ]),
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
          const Text(
            "Rs 2023",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          34.hGap,
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
          const Text(
            "Rs ${5656}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
