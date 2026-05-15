import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridBuilder {
  static Widget cardGrid({
    double maxCrossAxisExtent = 150.0,
    required List<Widget> children,
    bool shrinkWrap = true,
  }) {
    return GridView.extent(
      shrinkWrap: shrinkWrap,
      maxCrossAxisExtent: maxCrossAxisExtent,
      children: children,
    );
  }
}
