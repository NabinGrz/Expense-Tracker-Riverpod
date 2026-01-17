import 'package:expense_tracker_flutter/features/filter/widgets/filter_type_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverHomeAppBar extends StatelessWidget {
  final void Function()? onPressed;
  const SliverHomeAppBar({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      expandedHeight: 60,
      title: const Text(
        "Kharcha",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      actions: [
        // IconButton(
        //   splashRadius: 20,
        //   onPressed: () {
        //     // showCupertinoModalPopup(
        //     //   context: context,
        //     //   builder: (BuildContext context) =>
        //     //       showFilterTypeBottomSheet(context),
        //     // );
        //   },
        //   icon: const Icon(Icons.system_update_rounded),
        // ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) =>
                  showFilterTypeBottomSheet(context),
            );
          },
          icon: const Icon(CupertinoIcons.calendar),
        ),
      ],
    );
  }
}
