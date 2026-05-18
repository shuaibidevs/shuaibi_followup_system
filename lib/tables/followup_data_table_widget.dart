import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../api/gsheets_api.dart';
import '../models/worksheet_data_model.dart';
import '../models/worksheet_model.dart';
import '../services/database_service.dart';
import '../table_controllers/followup_table_controller.dart';

class FollowupDataTableWidget extends StatefulWidget {
  final WorksheetDataModel worksheetDataModel;
  final DatabaseService databaseService;
  // final Function(WorksheetDataModel v) onSheetUpdated;

  const FollowupDataTableWidget({
    super.key,
    required this.worksheetDataModel,
    required this.databaseService,
    // required this.onSheetUpdated,
  });

  @override
  State<FollowupDataTableWidget> createState() => _FollowDataTableWidgetState();
}

double _minWidth(int length) => length * 150.0;

class _FollowDataTableWidgetState extends State<FollowupDataTableWidget> {
  late FollowupTableController _followupTableController;

  @override
  void initState() {
    _followupTableController = FollowupTableController(
      context: context,
      databaseService: widget.databaseService,
      dataList: widget.worksheetDataModel.worksheetData,
      tableTitle: widget.worksheetDataModel.worksheetTitle,
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

      columns: _followupTableController.columns(),
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

  // void _filterMaker(BuildContext context) {
  //   List<Map<String, dynamic>> newDataList =
  //       _followupTableController.dataList.where((Map<String, dynamic> json) {
  //         if (json.containsKey('box') && json['box'] == 'pending') {
  //           return true;
  //         }
  //         return false;
  //       }).toList();
  //   setState(() {
  //     _followupTableController = FollowupTableController(
  //       context: context,
  //       dataList: newDataList,
  //       databaseService: widget.databaseService,
  //       tableId: widget.worksheetDataModel.worksheetId,
  //     );
  //   });
  // }

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
          setState(() {
            _followupTableController = FollowupTableController(
              context: context,
              databaseService: widget.databaseService,
              dataList: worksheetDataModel.worksheetData,

              tableTitle: worksheetDataModel.worksheetTitle,
              tableId: worksheetDataModel.worksheetId,
            );
          });
          // widget.onSheetUpdated(worksheetDataModel);
        }
      });
    }
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
