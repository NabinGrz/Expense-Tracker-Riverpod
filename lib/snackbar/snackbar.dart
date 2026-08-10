import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Everything related to the snackbar that we are showing throughout the app

enum SnackBarTypes {
  // ignore: constant_identifier_names
  Custom,
  // ignore: constant_identifier_names
  Error,
  // ignore: constant_identifier_names
  Warning,
  // ignore: constant_identifier_names
  Success,
  // ignore: constant_identifier_names
  Info,
  //If any type added here, don't forget to add corresponding _backgroundColor
  // in showSnackBar
}

void showSnackBar({
  String title = '',
  required String message,
  SnackBarTypes? type,
  Color? backgroundColor,
  Color? textColor,
}) {
  //Setting Colors based on type
  final textColorToUse =
      type == SnackBarTypes.Custom ? textColor : Colors.white;
  final backgroundColorToUse = type == null
      ? Colors.green
      : type == SnackBarTypes.Custom
          ? backgroundColor
          : type == SnackBarTypes.Error
              ? Colors.red
              : type == SnackBarTypes.Warning
                  ? Colors.amber
                  : type == SnackBarTypes.Info
                      ? Colors.blue
                      : Colors.green;

  final finalMessage =
      "$title${title.isEmpty || message.isEmpty ? '' : ': '}$message";
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: finalMessage,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColorToUse,
    textColor: textColorToUse,
    fontSize: 16.0,
  );
}
