import 'package:expense_tracker_flutter/constants/app_color.dart';
import 'package:expense_tracker_flutter/features/filter/widgets/filter_type_widget.dart';
import 'package:expense_tracker_flutter/features/home/widgets/create_expense_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0x000000ff),
      elevation: 0,
      title: const Text(
        "Kharcha",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 32,
        ),
      ),
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () {
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
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);
}
