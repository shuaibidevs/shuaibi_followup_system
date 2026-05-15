import 'package:flutter/material.dart';

import '../models/table_settings_model.dart';
import '../table_helpers/table_settings_helper.dart';

class FilterPickerDialogWidget extends StatefulWidget {
  final String column;
  final List<Map<String, dynamic>> dataList;
  final VoidCallback onFilterChanged;
  final String tableId;
  const FilterPickerDialogWidget({
    super.key,
    required this.column,
    required this.dataList,
    required this.onFilterChanged,
    required this.tableId,
  });

  @override
  State<FilterPickerDialogWidget> createState() =>
      _FilterPickerDialogWidgetState();
}

class _FilterPickerDialogWidgetState extends State<FilterPickerDialogWidget> {
  @override
  void initState() {
    // TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
    //   tableId: widget.tableId,
    // );
    // Map<String, List<String>>? filter = Map<String, List<String>>.from(
    //   tableSettingsHelper.read()['filter'] ?? {},
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200.0,
          child: SingleChildScrollView(child: Column(children: _list())),
        ),
        // TextButton(
        //   onPressed: () {
        //     // TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
        //     //   tableId: widget.tableId,
        //     // );
        //     // tableSettingsHelper.save(
        //     //   TableSettingsModel(filter: {widget.column: _pickedList}),
        //     // );
        //   },
        //   child: Text('Apply'),
        // ),
      ],
    );
  }

  List<Widget> _list() {
    // !_read().toSet().containsAll(_filterValue())
    return [
      Row(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _addAll();
              });

              widget.onFilterChanged();
              // Navigator.pop(context);
            },
            child: Text('SELECT ALL'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _removeAll();
              });

              widget.onFilterChanged();
              // Navigator.pop(context);
            },
            child: Text('CLEAR'),
          ),
        ],
      ),
      ..._filterValue().map((cellValue) {
        return CheckboxListTile(
          value: _read().contains(cellValue) || _read().isEmpty,
          onChanged: (_) {
            if (_read().contains(cellValue)) {
              setState(() {
                _remove(cellValue);
              });
            } else {
              setState(() {
                _add(cellValue);
              });
            }
            widget.onFilterChanged();
          },
          title: Text(cellValue.toUpperCase()),
        );
      }),
    ];
  }

  List<String> _filterValue() {
    return widget.dataList
        .map((Map<String, dynamic> row) => row[widget.column].toString())
        .where((element) => element.trim().isNotEmpty)
        .toSet()
        .toList();
  }

  List<String> _read() {
    TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
      tableId: widget.tableId,
    );
    Map<String, List<String>>? filter = Map<String, List<String>>.from(
      tableSettingsHelper.read()['filter'] ?? {},
    );

    return filter[widget.column] ?? [];
  }

  _remove(String value) async {
    TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
      tableId: widget.tableId,
    );
    Map<String, List<String>>? filter = Map<String, List<String>>.from(
      tableSettingsHelper.read()['filter'] ?? {},
    );
    List<String> l = _read();
    bool remove = l.remove(value);
    filter.update(widget.column, (value) => l, ifAbsent: () => l);
    if (remove) {
      await tableSettingsHelper.save(TableSettingsModel(filter: filter));
    }
  }

  _add(String value) async {
    TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
      tableId: widget.tableId,
    );
    Map<String, List<String>>? filter = Map<String, List<String>>.from(
      tableSettingsHelper.read()['filter'] ?? {},
    );
    List<String> l = _read();
    l.add(value);
    filter.update(widget.column, (value) => l, ifAbsent: () => l);
    await tableSettingsHelper.save(TableSettingsModel(filter: filter));
  }

  _addAll() async {
    TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
      tableId: widget.tableId,
    );
    Map<String, List<String>>? filter = Map<String, List<String>>.from(
      tableSettingsHelper.read()['filter'] ?? {},
    );

    List<String> l = _read();
    l.addAll(_filterValue());
    filter.update(widget.column, (value) => l, ifAbsent: () => l);
    await tableSettingsHelper.save(TableSettingsModel(filter: filter));
  }

  _removeAll() async {
    TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
      tableId: widget.tableId,
    );
    Map<String, List<String>>? filter = Map<String, List<String>>.from(
      tableSettingsHelper.read()['filter'] ?? {},
    );

    List<String> l = _read();
    l.clear();
    filter.update(widget.column, (value) => l, ifAbsent: () => l);
    await tableSettingsHelper.save(TableSettingsModel(filter: filter));
  }

  bool _tableExists() {
    TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
      tableId: widget.tableId,
    );

    return tableSettingsHelper.exists();
  }
}
