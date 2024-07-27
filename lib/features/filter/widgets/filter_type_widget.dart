import 'package:expense_tracker_flutter/extension/sizebox_extension.dart';
import 'package:expense_tracker_flutter/features/filter/pages/filter_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterTypeBottomSheet extends StatelessWidget {
  const FilterTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 26,
          vertical: 26,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Filter Type",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.clear),
                ),
              ],
            ),
            48.hGap,
            InkWell(
              splashColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) {
                    return const FilterScreen(
                      isSpecificDate: true,
                    );
                  },
                ));
              },
              child: Row(
                children: [
                  const Icon(CupertinoIcons.today),
                  16.wGap,
                  const Text(
                    "Specific Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            34.hGap,
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) {
                    return const FilterScreen(
                      isSpecificDate: false,
                    );
                  },
                ));
              },
              child: Ink(
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.calendar),
                    16.wGap,
                    const Text(
                      "Date Range",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
