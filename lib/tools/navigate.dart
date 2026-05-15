import 'package:flutter/material.dart';

class Navigate {
  final BuildContext context;

  Navigate(this.context);
  to({required Widget page}) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  back() => Navigator.of(context).pop();
}
