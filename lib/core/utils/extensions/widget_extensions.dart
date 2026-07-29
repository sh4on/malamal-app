import 'package:flutter/material.dart';

/// global widget extension helpers
extension WidgetPaddingX on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);
}
