import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/gsheets_api.dart';
import '../models/worksheet_data_model.dart';
import '../models/worksheet_model.dart';
import '../services/database_service.dart';
import '../tools/data_builder.dart';
import 'list_builder.dart';

class ListOfWorksheetsDialogWidget extends StatefulWidget {
  final List<WorksheetDataModel> existingWorksheetTitles;
  final DatabaseService databaseService;
  final VoidCallback onSheetAdded;
  const ListOfWorksheetsDialogWidget({
    super.key,
    required this.existingWorksheetTitles,
    required this.databaseService,
    required this.onSheetAdded,
  });

  @override
  State<ListOfWorksheetsDialogWidget> createState() =>
      _ListOfWorksheetsDialogWidgetState();
}

late Future<List<WorksheetModel>> _worksheetsFuture;

class _ListOfWorksheetsDialogWidgetState
    extends State<ListOfWorksheetsDialogWidget> {
  @override
  void initState() {
    super.initState();
    _worksheetsFuture = GsheetsApi.listOfWorksheets();
  }

  WorksheetModel? pickedWorksheet;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.2,
      height: MediaQuery.sizeOf(context).width * 0.2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: SingleChildScrollView(child: _body())),
          _actionButtns(
            onCancel: () {
              Navigator.pop(context);
            },
            onAdd: () {
              _addWorksheet(pickedWorksheet);

              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<WorksheetModel>> _body() {
    return DataBuilder.futureBuilder(
      future: _worksheetsFuture,
      builder: (context, snapshot) {
        final List<WorksheetModel> listOfWorksheets = snapshot.data!;

        final cards = List<Widget>.from(
          listOfWorksheets.map<Widget>((worksheet) {
            bool exists = _sheetExists(worksheet.title);

            return _buildCard(
              worksheet: worksheet,
              pickedWorksheet: pickedWorksheet,
              onTap:
                  exists
                      ? null
                      : () {
                        setState(() {
                          pickedWorksheet = worksheet;
                        });
                        // Navigator.of(context).pop();
                      },
            );
          }),
        );
        return ListBuilder.cardList(children: cards);
      },
    );
  }

  bool _sheetExists(String title) {
    for (WorksheetDataModel worksheetTitle in widget.existingWorksheetTitles) {
      if (worksheetTitle.worksheetTitle == title) {
        return true;
      }
    }
    return false;
  }

  void _addWorksheet(WorksheetModel? worksheet) async {
    if (worksheet == null) {
      return;
    }
    List<Map<String, dynamic>> worksheetData =
        await GsheetsApi.valuesAsJsonList(worksheet);
    final newFollowupDataList = WorksheetDataModel(
      worksheetId: worksheet.id,
      worksheetTitle: worksheet.title,
      worksheetData: worksheetData,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    // Add the new WorksheetDataModel to Firestore
    widget.databaseService
        .createFollowupDataWithId(newFollowupDataList)
        .whenComplete(() {
          widget.onSheetAdded();
        });
  }
}

Widget _buildCard({
  required WorksheetModel worksheet,
  required WorksheetModel? pickedWorksheet,
  required VoidCallback? onTap,
}) {
  BorderRadius borderRadius = BorderRadius.circular(10.0);
  return Opacity(
    opacity: onTap == null ? 0.3 : 1.0,
    child: Card(
      elevation:
          worksheet.title == pickedWorksheet?.title || onTap == null
              ? 0.0
              : 1.5,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          alignment: Alignment.center,
          child: Text(
            worksheet.title,
            style:
                worksheet.title == pickedWorksheet?.title
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : null,
          ),
        ),
      ),
    ),
  );
}

Widget _actionButtns({
  required VoidCallback onCancel,
  required VoidCallback onAdd,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(onPressed: onCancel, child: const Text('CANCEL')),
      TextButton(onPressed: onAdd, child: const Text('ADD')),
    ],
  );
}
