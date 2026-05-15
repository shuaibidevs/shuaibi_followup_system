import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListBuilder {
  static Widget cardList({
    required List<Widget> children,
    bool shrinkWrap = true,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ListView.builder(
        shrinkWrap: shrinkWrap,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}
