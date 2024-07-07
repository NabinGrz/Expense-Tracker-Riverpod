import 'package:flutter/material.dart';

extension SizedShape on num {
  SizedBox get hGap => SizedBox(
        height: toDouble(),
      );
  SizedBox get wGap => SizedBox(
        width: toDouble(),
      );
}
