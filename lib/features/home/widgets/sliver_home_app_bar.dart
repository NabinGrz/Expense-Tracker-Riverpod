import 'package:expense_tracker_flutter/features/filter/widgets/filter_type_widget.dart';
import 'package:expense_tracker_flutter/features/home/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliverHomeAppBar extends StatelessWidget {
  const SliverHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      expandedHeight: 60,
      title: const Text(
        "Kharcha",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
            splashRadius: 20,
            onPressed: () {
              HapticFeedback.selectionClick();
              showCupertinoModalPopup(
                context: context,
                builder: (context) => const FilterTypeBottomSheet(),
              );
            },
            icon: const Icon(CupertinoIcons.calendar)),
      ],
    );
  }
}
