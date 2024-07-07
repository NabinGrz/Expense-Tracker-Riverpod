import 'package:flutter/cupertino.dart';

class AddNewExpenseDialog extends StatelessWidget {
  const AddNewExpenseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Alert'),
      content: Column(
        children: [
          const CupertinoTextField(
            placeholder: "Name...",
          ),
          CupertinoPicker.builder(
            childCount: 10,
            itemExtent: 20,
            itemBuilder: (context, index) {
              return const Text("dadsah");
            },
            onSelectedItemChanged: (value) {},
          ),
          const CupertinoTextField(
            placeholder: "Amount...",
          ),
        ],
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        CupertinoDialogAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as deletion, and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
