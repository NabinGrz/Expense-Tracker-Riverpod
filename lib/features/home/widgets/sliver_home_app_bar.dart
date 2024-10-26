import 'package:expense_tracker_flutter/features/filter/widgets/filter_type_widget.dart';
import 'package:expense_tracker_flutter/features/home/screen/search_screen.dart';
import 'package:expense_tracker_flutter/features/home/widgets/create_expense_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SliverHomeAppBar extends StatelessWidget {
  final void Function() onRefresh;
  const SliverHomeAppBar({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // pinned: true,
      floating: true,
      expandedHeight: 60,
      // flexibleSpace: const Placeholder(),
      title: const Text(
        "Kharcha",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => const SearchExpenseScreen(),
            ));
          },
          icon: const Icon(CupertinoIcons.search),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            HapticFeedback.selectionClick();
            showCupertinoModalPopup(
              context: context,
              builder: (context) => const FilterTypeBottomSheet(),
            );
          },
          icon: SvgPicture.asset("assets/images/filter.svg"),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            HapticFeedback.selectionClick();
            showDialog(
              context: context,
              builder: (context) {
                return const CreateUpdateDialog(
                  isUpdate: false,
                );
              },
            );
          },
          icon: SvgPicture.asset("assets/images/add.svg"),
        ),
      ],
    );
  }
}
