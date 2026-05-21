import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridBuilder {
  static Widget cardGrid({
    double maxCrossAxisExtent = 150.0,
    required List<Widget> children,
    bool shrinkWrap = true,
    double childAspectRatio = 1.0,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
  }) {
    return GridView.extent(
      shrinkWrap: shrinkWrap,
      childAspectRatio: childAspectRatio,
      maxCrossAxisExtent: maxCrossAxisExtent,
      children: children,
    );
  }
}
