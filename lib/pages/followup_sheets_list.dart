import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/worksheet_data_model.dart';
import '../services/database_service.dart';
import '../tools/data_builder.dart';
import '../tools/dialogs.dart';
import '../tools/navigate.dart';
import '../widgets/grid_builder.dart';
import '../widgets/list_of_worksheets_dialog_widget.dart';
import 'single_followup_sheet.dart';

class FollowupSheetsList extends StatefulWidget {
  final DatabaseService databaseService;
  const FollowupSheetsList({super.key, required this.databaseService});

  @override
  State<FollowupSheetsList> createState() => _FollowupSheetsListState();
}

class _FollowupSheetsListState extends State<FollowupSheetsList> {
  List<WorksheetDataModel> _followupDataModelList = [];
  Stream<DatabaseResult<QuerySnapshot<WorksheetDataModel>>>? _followupData;
  @override
  void initState() {
    _followupData = widget.databaseService.readFollowupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FollowUp Sheets List')),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _body() {
    return DataBuilder.streamBuilder(
      stream: _followupData,
      builder: (context, snapshot) {
        final result = snapshot.data!;
        if (result.isError) {
          return Center(child: Text('Database Error: ${result.error}'));
        }

        final querySnapshot = result.data!;
        final docs = querySnapshot.docs;

        _followupDataModelList =
            docs.map((QueryDocumentSnapshot<WorksheetDataModel> doc) {
              try {
                final data = doc.data();
                return data;
              } catch (e) {
                return WorksheetDataModel(
                  worksheetId: '',
                  worksheetTitle: 'no worksheet found',
                  worksheetData: [],
                  createdAt: Timestamp.now(),
                  updatedAt: Timestamp.now(),
                );
              }
            }).toList();

        return GridBuilder.cardGrid(children: _list());
      },
    );
  }

  List<Widget> _list() {
    List<Widget> returnList = [];

    for (WorksheetDataModel worksheetDataModel in _followupDataModelList) {
      returnList.add(
        _buildCard(
          followupData: worksheetDataModel,
          onTap: () {
            Navigate(context).to(
              page: SingleFollowupSheet(
                worksheetDataModel: worksheetDataModel,
                databaseService: widget.databaseService,
              ),
            );
          },
        ),
      );
    }
    return returnList;
  }

  Widget _buildCard({
    required WorksheetDataModel followupData,
    required VoidCallback? onTap,
  }) {
    BorderRadius borderRadius = BorderRadius.circular(10);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Center(child: Text(followupData.worksheetTitle)),
      ),
    );
  }

  void _dialog() {
    Dialogs.dialog(
      context: context,
      title: 'Add Worksheet',
      content: ListOfWorksheetsDialogWidget(
        existingWorksheetTitles: _followupDataModelList,
        databaseService: widget.databaseService,
        onSheetAdded: () {
          setState(() {
            _followupData = widget.databaseService.readFollowupData();
            // _followupData.
          });
        },
      ),
    );
  }
}
