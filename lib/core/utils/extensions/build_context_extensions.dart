import 'package:flutter/material.dart';

/// context extension helpers
extension ContextX on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}
