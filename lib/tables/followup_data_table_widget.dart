import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:shuaibi_followup_system/api/gsheets_api.dart';

import '../models/worksheet_data_model.dart';
import '../models/worksheet_model.dart';
import '../services/database_service.dart';
import '../table_controllers/followup_table_controller.dart';
import '../tools/dialogs.dart';
import '../tools/screen_size.dart';
import '../widgets/filter_picker_dialog_widget.dart';
import '../widgets/material_info_card_dialog_widget.dart';

class FollowupDataTableWidget extends StatefulWidget {
  final WorksheetDataModel worksheetDataModel;
  final List<String> visibleColumns;
  final Map<String, Set<String>> rowFilters;
  final Function(String column, Set<String> values)? onFilterChanged;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String column)? onSortChanged;
  final DatabaseService databaseService;
  final Function(WorksheetDataModel v) onSheetUpdated;

  const FollowupDataTableWidget({
    super.key,
    required this.worksheetDataModel,
    required this.visibleColumns,
    this.rowFilters = const {},
    this.onFilterChanged,
    this.sortColumn,
    this.sortAscending = true,
    this.onSortChanged,
    required this.databaseService,
    required this.onSheetUpdated,
  });

  @override
  State<FollowupDataTableWidget> createState() => _FollowDataTableWidgetState();
}

double _minWidth(int length) => length * 150.0;

class _FollowDataTableWidgetState extends State<FollowupDataTableWidget> {
  late FollowupTableController _followupTableController;
  final List<Map<String, List<String>>> _filterMap = [
    // {
    //   'bottle': ['pending'],
    // },
  ];

  @override
  void initState() {
    _followupTableController = FollowupTableController(
      context: context,
      databaseService: widget.databaseService,
      dataList: widget.worksheetDataModel.worksheetData,
      filterMap: _filterMap,
      tableId: widget.worksheetDataModel.worksheetId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      empty: const Text('empty'),
      rowsPerPage: 50,
      renderEmptyRowsInTheEnd: false,
      minWidth: _minWidth(_followupTableController.columnsCount),
      columnSpacing: 5.0,

      columns: _followupTableController.columns(onColumnTap: _onColumnTap),
      source: TableDataSource(dataRow: _followupTableController.rows()),
      border: TableBorder(
        verticalInside: BorderSide(color: Colors.grey.shade300, width: 1),
        horizontalInside: BorderSide(color: Colors.grey.shade300, width: 0.5),
        top: BorderSide(color: Colors.grey.shade400, width: 1),
        bottom: BorderSide(color: Colors.grey.shade400, width: 1),
        left: BorderSide(color: Colors.grey.shade400, width: 1),
        right: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      header: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'last updated: ${_lastUpdatedTime()}',
            style: TextStyle(fontSize: 14.0),
          ),
          TextButton(onPressed: _updateSheet, child: Text('Update')),
        ],
      ),
    );
  }

  String _lastUpdatedTime() {
    if (widget.worksheetDataModel.worksheetData.isEmpty) {
      return 'N/A';
    }
    DateTime lastUpdated = widget.worksheetDataModel.updatedAt.toDate();
    String formattedDate =
        '${lastUpdated.year}-${lastUpdated.month.toString().padLeft(2, '0')}-${lastUpdated.day.toString().padLeft(2, '0')}';
    String formattedTime =
        '${lastUpdated.hour.toString().padLeft(2, '0')}:${lastUpdated.minute.toString().padLeft(2, '0')}';
    // String amPm = lastUpdated.hour >= 12 ? 'PM' : 'AM';
    return '$formattedDate , $formattedTime';
  }

  _updateSheet() async {
    List<WorksheetModel> worksheetModelList =
        await GsheetsApi.listOfWorksheets();
    WorksheetModel? c;
    for (final worksheetModel in worksheetModelList) {
      if (worksheetModel.id == widget.worksheetDataModel.worksheetId) {
        c = worksheetModel;
        break;
      }
    }
    if (c != null) {
      await GsheetsApi.valuesAsJsonList(c);
      WorksheetDataModel worksheetDataModel = widget.worksheetDataModel
          .copyWith(
            null,
            null,
            await GsheetsApi.valuesAsJsonList(c),
            null,
            Timestamp.now(),
          );
      widget.databaseService.updateFollowupData(worksheetDataModel).then((
        value,
      ) {
        if (value.isSuccess) {
          widget.onSheetUpdated(worksheetDataModel);
        }
      });
    }
  }

  void _onColumnTap(String column) {
    // Dialogs.dialog(
    //   context: context,
    //   title: column,
    //   content: FilterPickerDialogWidget(
    //     column: column,
    //     dataList: _followupTableController.dataList,
    //     tableId: widget.worksheetDataModel.worksheetId,
    //     onFilterChanged: () {
    //       setState(() {});
    //     },
    //   ),
    // );
  }
  // void _onColumnTap(String column) {
  //   Set<String> uniqueValues = {};
  //   for (var row in widget.worksheetDataModel.worksheetData) {
  //     String value = row[column]?.toString() ?? 'N/A';
  //     uniqueValues.add(value);
  //   }
  //   // List.from(_filterMap.map((e) => e.values)).se;

  //   Set<String> selectedValues = widget.rowFilters[column] ?? {};
  //   Set<String> tempValues = {...selectedValues};

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter ss) {
  //           return AlertDialog(
  //             title: Text('Filter: ${column.toUpperCase()}'),
  //             content: SizedBox(
  //               width: 300,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     CheckboxListTile(
  //                       title: const Text('Show All'),
  //                       value: tempValues.length == uniqueValues.length,
  //                       onChanged: (_) {
  //                         ss(() {
  //                           if (tempValues.length == uniqueValues.length) {
  //                             tempValues.clear();
  //                           } else {
  //                             tempValues = {...uniqueValues};
  //                           }
  //                         });
  //                       },
  //                     ),
  //                     ...uniqueValues.toList().asMap().entries.map((entry) {
  //                       String value = entry.value;
  //                       return CheckboxListTile(
  //                         title: Text(value),
  //                         value: tempValues.contains(value),
  //                         onChanged: (_) {
  //                           ss(() {
  //                             if (tempValues.contains(value)) {
  //                               tempValues.remove(value);
  //                             } else {
  //                               tempValues.add(value);
  //                             }
  //                           });
  //                         },
  //                       );
  //                     }),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   // widget.onFilterChanged?.call(column, tempValues);
  //                   setState(() {
  //                     _filterMap.add({column: tempValues.toList()});
  //                   });
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Apply'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _onCellTapDialogContent(Map<String, dynamic> data, String mapKey) {
    return SizedBox(
      width: ScreenSize.width * .2,
      // height: double.min,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.S,
            children: [
              Expanded(
                child: MaterialInfoCardDialogWidget(
                  map: data,
                  mapKey: mapKey,
                  databaseService: widget.databaseService,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TableDataSource extends DataTableSource {
  final List<DataRow2> dataRow;
  TableDataSource({required this.dataRow});

  @override
  DataRow? getRow(int index) {
    return dataRow[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataRow.length;

  @override
  int get selectedRowCount => 0;
}
