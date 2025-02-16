import 'package:expense_tracker_flutter/features/filter/widgets/filter_type_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () {
            // Navigator.push(
            //   context,
            //   CupertinoSheetRoute(
            //     builder: (context) => const FilterTypeBottomSheet(),
            //   ),
            // );
            // showCupertinoModalPopup(
            //     context: context,
            //     builder: (context) => const CupertinoActionSheet(
            //         title: Text('Choose Options'),
            //         message: Text('Your options are'),
            //         actions: <Widget>[]));
            showCupertinoModalPopup(
              context: context,
              // semanticsDismissible: true,
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
