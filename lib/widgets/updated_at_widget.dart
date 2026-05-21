import 'dart:async';
import 'package:flutter/material.dart';

import '../tools/datetime_to_statement.dart';

class UpdatedAtWidget extends StatefulWidget {
  final DateTime dateTime;
  final Future<void> Function() onUpdate;

  const UpdatedAtWidget({
    super.key,
    required this.dateTime,
    required this.onUpdate,
  });

  @override
  State<UpdatedAtWidget> createState() => _UpdatedAtWidgetState();
}

class _UpdatedAtWidgetState extends State<UpdatedAtWidget> {
  late Timer timer;
  String _u = 'update';
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DatetimeToStatement.from(widget.dateTime),
          style: TextStyle(fontSize: 14.0),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _u = '...';
            });
            widget.onUpdate().then((v) {
              // refresh immediately
              setState(() {
                _u = 'update';
              });
            });
          },
          child: Text(_u),
        ),
      ],
    );
  }
}
