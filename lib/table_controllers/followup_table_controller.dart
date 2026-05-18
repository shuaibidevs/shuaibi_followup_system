import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../models/followup_sheet_model.dart';
import '../services/database_service.dart';
import '../tools/consts.dart';
import '../tools/dialogs.dart';
import '../tools/screen_size.dart';
import '../widgets/material_info_card_dialog_widget.dart';

class FollowupTableController {
  final BuildContext context;
  final DatabaseService databaseService;
  final List<Map<String, dynamic>> dataList;
  final String tableId;
  final String tableTitle;

  FollowupTableController({
    required this.context,
    required this.databaseService,
    required this.dataList,
    required this.tableId,
    required this.tableTitle,
  });

  int get columnsCount => Consts.columns.length;

  List<FollowupSheetModel> get _rows {
    List<Map<String, dynamic>> list =
        dataList.map((Map<String, dynamic> data) {
          return Map.fromEntries(
            data.entries.where((element) {
              return Consts.columns.contains(element.key);
            }),
          );
        }).toList();
    return list.map((json) {
      return FollowupSheetModel.fromJson(json);
    }).toList();
  }

  List<DataColumn2> columns() {
    List<DataColumn2> cols =
        Consts.columns
            .map(
              (column) => DataColumn2(
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(column.toString().toUpperCase()),
              ),
            )
            .toList();

    return cols;
  }

  List<DataRow2> rows() {
    List<DataRow2> rowss =
        _rows.map((FollowupSheetModel model) {
          final Map<String, dynamic> data = model.toJson();

          return DataRow2(
            cells:
                Consts.columns.map((String column) {
                  return DataCell(_dataCellContent(column: column, data: data));
                }).toList(),
          );
        }).toList();

    return rowss;
  }

  Widget _dataCellContent({
    required String column,
    required Map<String, dynamic> data,
  }) {
    return Container(
      alignment: Alignment.center,
      margin: !_statusCell(column) ? null : EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _statusColor(column, data[column]),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap:
            !_statusCell(column)
                ? null
                : () {
                  Dialogs.dialog(
                    context: context,
                    title:
                        "${data['brand']} ${data['perfume']} ($column)"
                            .toUpperCase(),
                    content: _onCellTapDialogContent(data, column),
                  );
                },
        splashFactory: NoSplash.splashFactory,
        child: Text(
          data[column].toString().toUpperCase(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _onCellTapDialogContent(Map<String, dynamic> data, String column) {
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
                  databaseService: databaseService,
                  map: data,
                  mapKey: column,
                  tableId: tableId,
                  tableTitle: tableTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color? _statusColor(String column, dynamic cell) {
    if (_statusCell(column)) {
      switch (cell.toString().toLowerCase()) {
        case 'pending':
          return Colors.red.shade100;
        case 'in transit':
          return Colors.blue.shade100;
        case 'on production':
          return Colors.amber.shade100;
        case 'done':
          return Colors.green.shade100;
        case 'delivered':
          return Colors.blueGrey.shade100;
        default:
          return Colors.grey.shade400;
      }
    }
    return null;
  }

  bool _statusCell(String column) {
    return column == Consts.columns.elementAt(6) ||
        column == Consts.columns.elementAt(7) ||
        column == Consts.columns.elementAt(8) ||
        column == Consts.columns.elementAt(9) ||
        column == Consts.columns.elementAt(10) ||
        column == Consts.columns.elementAt(11);
  }
}
