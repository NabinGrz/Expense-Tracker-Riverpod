import 'package:expense_tracker_flutter/features/filter/widgets/filter_type_widget.dart';
import 'package:expense_tracker_flutter/features/settings/screen/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverHomeAppBar extends StatelessWidget {
  final void Function()? onPressed;
  const SliverHomeAppBar({super.key, required this.onPressed});

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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
        //   splashRadius: 20,
        //   onPressed: () async {
        //     //!! Delete old data from firebase
        //     final querySnapshot =
        //         await FirebaseQueryHelper.getCollectionAsFuture(
        //           collectionPath: "expenses",
        //         );
        //     if (querySnapshot != null) {
        //       for (var doc in querySnapshot.docs) {
        //         final expense = Expense.fromJson(jsonEncode(doc.data()));
        //         final createDate = DateTime.parse(expense.createAt);
        //         if (createDate.isBefore(DateTime(2026, 1, 1))) {
        //           FirebaseQueryHelper.deleteDocumentOfCollection(
        //             collectionID: "expenses",
        //             docID: doc.id,
        //           );
        //           print("Deleted: ${doc.id}");
        //         }
        //       }
        //     }
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
