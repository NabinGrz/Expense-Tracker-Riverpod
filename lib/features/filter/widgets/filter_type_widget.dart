import 'package:expense_tracker_flutter/features/filter/pages/filter_screen.dart';
import 'package:flutter/cupertino.dart';

CupertinoActionSheet showFilterTypeBottomSheet(BuildContext context) {
  return CupertinoActionSheet(
    title: const Text("Select Filter Type"),
    message: const Text('Please select the filter type from the options below'),
    actions: <Widget>[
      CupertinoActionSheetAction(
        isDefaultAction: true,
        child: const Text("Specific Date"),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, CupertinoSheetRoute(
            builder: (context) {
              return const FilterScreen(
                isSpecificDate: true,
              );
            },
          ));
        },
      ),
      CupertinoActionSheetAction(
        isDefaultAction: true,
        child: const Text("Date Range"),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, CupertinoSheetRoute(
            builder: (context) {
              return const FilterScreen(
                isSpecificDate: false,
              );
            },
          ));
        },
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
