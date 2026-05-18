import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';

import '../models/worksheet_model.dart';
import '../tools/list_to_json.dart';

class GsheetsApi {
  static const String _gsid = '1T-g6_d285V7SAVFlXXUiwGCvzXKVVcCl627jEvTixYM';

  static late GSheets _gsheets;

  static Spreadsheet? spreadsheet;

  // INIT
  static Future<String?> init() async {
    try {
      // LOAD LOCAL JSON FILE
      final credentials = await rootBundle.loadString(
        'assets/credentials/service_account.json',
      );

      // CREATE GSHEETS INSTANCE
      _gsheets = GSheets(credentials);

      // OPEN SPREADSHEET
      spreadsheet = await _gsheets.spreadsheet(_gsid);
      return null;
    } on GSheetsException catch (m, _) {
      return "Google Sheets Error: ${m.cause}";
    }
  }

  // SPREADSHEET TITLE
  static Future<String> title() async {
    Spreadsheet ss = spreadsheet ?? await _gsheets.spreadsheet(_gsid);

    return ss.data.properties.title ?? "Title";
  }

  // LIST OF WORKSHEETS
  static Future<List<WorksheetModel>> listOfWorksheets() async {
    Spreadsheet ss = spreadsheet ?? await _gsheets.spreadsheet(_gsid);

    List<WorksheetModel> sheets = [];

    for (Worksheet sheet in ss.sheets) {
      WorksheetModel model = WorksheetModel(
        spreadsheetId: sheet.spreadsheetId,
        id: sheet.id.toString(),
        title: sheet.title,
        index: sheet.index.toString(),
        rowCount: sheet.rowCount.toString(),
        columnCount: sheet.columnCount.toString(),
      );

      sheets.add(model);
    }

    return sheets;
  }

  // ALL SHEET VALUES AS LIST
  static Future<List<List<String>>> _allValuesList(
    WorksheetModel worksheet,
  ) async {
    Spreadsheet ss = spreadsheet ?? await _gsheets.spreadsheet(_gsid);

    String title = worksheet.title;

    List<List<String>> allValuesList =
        await ss.worksheetByTitle(title)?.values.allRows() ?? [];

    return allValuesList;
  }

  // ALL SHEET VALUES AS JSON LIST
  static Future<List<Map<String, dynamic>>> valuesAsJsonList(
    WorksheetModel worksheet,
  ) async {
    List<List<String>> values = await _allValuesList(worksheet);

    return ListToJson(values).result();
  }

  static Future<WorksheetModel> worksheetTitleById(String id) async {
    List<WorksheetModel> worksheets = await listOfWorksheets();
    return worksheets.firstWhere(
      (element) => element.id == id,
      orElse:
          () => WorksheetModel(
            spreadsheetId: 'null',
            id: 'null',
            title: 'null',
            index: 'null',
            rowCount: 'null',
            columnCount: 'null',
          ),
    );
  }
}
