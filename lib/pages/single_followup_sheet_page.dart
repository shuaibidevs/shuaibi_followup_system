import 'package:flutter/material.dart';

import '../models/worksheet_data_model.dart';
import '../services/database_service.dart';
import '../tables/followup_data_table_widget.dart';

class SingleFollowupSheetPage extends StatefulWidget {
  final WorksheetDataModel worksheetDataModel;
  final DatabaseService databaseService;
  const SingleFollowupSheetPage({
    super.key,
    required this.worksheetDataModel,
    required this.databaseService,
  });

  @override
  State<SingleFollowupSheetPage> createState() =>
      _SingleFollowupSheetPageState();
}

class _SingleFollowupSheetPageState extends State<SingleFollowupSheetPage> {
  late WorksheetDataModel _wsdm;

  @override
  void initState() {
    _wsdm = widget.worksheetDataModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_wsdm.worksheetTitle)),
      body: FollowupDataTableWidget(
        worksheetDataModel: _wsdm,
        databaseService: widget.databaseService,
        // onSheetUpdated: (WorksheetDataModel v) {
        //   setState(() {
        //     _wsdm = v;
        //   });
        // },
      ),
    );
  }
}
