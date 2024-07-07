import 'package:expense_tracker_flutter/features/home/widgets/create_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
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
          onPressed: () {},
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
