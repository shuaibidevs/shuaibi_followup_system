import 'package:flutter/material.dart';

import '../models/table_settings_model.dart';
import '../models/worksheet_data_model.dart';
import '../services/database_service.dart';
import '../table_helpers/table_settings_helper.dart';
import '../tables/followup_data_table_widget.dart';

class SingleFollowupSheet extends StatefulWidget {
  final WorksheetDataModel worksheetDataModel;
  final DatabaseService databaseService;
  const SingleFollowupSheet({
    super.key,
    required this.worksheetDataModel,
    required this.databaseService,
  });

  @override
  State<SingleFollowupSheet> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SingleFollowupSheet> {
  late WorksheetDataModel _wsdm;
  final Map<String, Set<String>> _rowFilters =
      {}; // column -> set of values to show
  String? _sortColumn;
  bool _sortAscending = true;

  @override
  void initState() {
    _wsdm = widget.worksheetDataModel;
    super.initState();
  }

  void _updateFilter(String column, Set<String> values) {
    setState(() {
      if (values.isEmpty) {
        _rowFilters.remove(column);
      } else {
        _rowFilters[column] = values;
      }
    });
  }

  void _updateSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        // Toggle sort direction if same column
        _sortAscending = !_sortAscending;
      } else {
        // Set new sort column
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> visibleColumns = [
      'date',
      'no',
      'customer',
      'brand',
      'perfume',
      'quantity',
      'bottle',
      'coating & foiling',
      'cap',
      'oil',
      'box',
      'sticker',
      'remarks',
      'munir',
    ];
    return Scaffold(
      appBar: AppBar(title: Text(_wsdm.worksheetTitle)),
      body: FollowupDataTableWidget(
        worksheetDataModel: _wsdm,
        visibleColumns: visibleColumns,
        rowFilters: _rowFilters,
        onFilterChanged:
            (String column, Set<String> values) =>
                _updateFilter(column, values),
        sortColumn: _sortColumn,
        sortAscending: _sortAscending,
        onSortChanged: _updateSort,
        databaseService: widget.databaseService,
        onSheetUpdated: (WorksheetDataModel v) {
          setState(() {
            _wsdm = v;
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     TableSettingsHelper tableSettingsHelper = TableSettingsHelper(
      //       tableId: widget.worksheetDataModel.worksheetId,
      //     );
      //     tableSettingsHelper.clearSettings();
      //     // await followupTableHelper.save(
      //     //   TableSettingsModel(
      //     //     filter: {
      //     //       "bottle": ["pending"],
      //     //     },
      //     //   ),
      //     // );
      //     // print(followupTableHelper.read());
      //   },
      // ),
    );
  }
}
