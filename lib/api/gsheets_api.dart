// import 'package:gsheets/gsheets.dart';

// import '../models/worksheet_model.dart';
// import '../tools/list_to_json.dart';

// class GsheetsApi {

//  static const String _credentials ='''r {
//   "type": "service_account",
//   "project_id": "ancient-cortex-494707-k8",
//   "private_key_id": "2dea6f7288041b23b43256672eb815e94350d119",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDbP+9LYMcqDZao\nWp4m/FpQgQMTfg+hanAKyTfTKf+8f79TnMe8tEHrLThNDC5Do2HahJW7jflm4vrf\nfn2PrqsP42oAuI9dv1cTgsKA5igfDym16tErxqSMBrroJakfeV16hcR1bY5e4Jlu\nfwn8mPx0DA7+JfFAkSS6gMs2hgr/amIQlZrbitTMUPNQUxKFMZbKaM2dpD0Yhm6Q\ny/pzBOgKmpSJqrxDnSQnuZBOB9mP9rXSUbytxPrFGnqA5rZ1ezVBZ+VPM0vSYL8G\nbRvZs4v5DJjKp1O+hEb18mzknVNH12T+HbjICeLSJf58Q3f6cFSYv8jiEOKv+VjH\nvrn432zHAgMBAAECggEAASmNgeiPM5r4ou3HyZdSjx2QggsuAhmgL7NAhL6hwTXV\n5ZecrxBAYALDqPH5BPLX4zFxerOQA4ynO30V0A4WXVaQqof6nP372qBCM+oALdm0\n5RFt+7dC11KHz7tzHNgaTSEl8qUFVzt9Ypu+Iy1x6oIcqDxUZEFWD61R+85QT+Dr\nFN5583A09wO89DPl1VsofTWW9c/Kds68zurmPztOWFG6q/k7+XPlJLZ8bWjRmShm\nJSf8QRSboyJrxkwCYsAUMbYPnAXfPRUE2f1aWPG+jG//6Hjrvy9xpdzwIPW9dJPV\n7yvRhkbxLEeRQPGvBDHiXNMsc/tOmtxxIKe7qu6thQKBgQD/MIo/uTOT8lE9cvhE\n+14zJPwa6GLideOdNEt2visBYcKxFoLYsFpTjT/5A5GSe6Glsfpy4GoW8pZ25CL7\nSnvbRIfMikPS2KXN4p0TVe3xW521GvZFefwmyJYM1DKO+OuT7alw5mEaemKOJrvA\nE1x8TH/r/qNGXXjKjOGEryH1FQKBgQDb8i1I39xMWtgRRoL7k0Ntl8J83oE7DQiJ\nv/Gxg7brL0j5Z8eS//2hEmjV06BLw2fTUlMng/hJ6n5VdhF0gs4GUMjSfMOcOtkt\nKSnmQQuoSMjljIxGENywhHb7HqLm83ZbYxzMJWYWQldL5s5Puv1tbQlN7UHm3TBG\nGKFilF9JawKBgQCE7Wn2S6icVksPMUY12KJ3Dbrs4UQxJquMBeORVPnd3GioCkva\nR/KlNxytv7gij5fiUdVd5Zwdm/vYrnmyYFgoHYiHeTZfLE8h8ftUSRyK7ug1oHfM\nNQCtyyquQBKd+vfrtI7gqoDGZB3WYkLGiM9SSB8SdS/jxWjYSY5nqTqNCQKBgQCt\nr6PVHXqRDVf85GrBEby4iZQ7GVaB9Dve06WgIbxMIq4EzdBLJD38eVYyLQkzax7N\nQQCLfuqOLFARWshT8ouRby/3EDFEaTBhOlVtD8aN4NRMeV24Ys5z0ldG3R2VNYMs\njasLBymDwGXBeYVIbwh75hPn5skY72iUohSnjTVl+wKBgHpR8EB0J18xv9C3kxfM\nfPSzUEVkSemUCPfRIOJPuXoy/xQP80rhyC9qkYwwol9zniOJEMq8p5sT55hDD0Nh\nsdyAWeeN+Ym9ZGgj6AGuhm21ogCQODV8iCaYf5Ydx8m6FALiJWpMYxOLhA0HPCjP\nPun1yrZhQ3OJ1dynUpxPIJya\n-----END PRIVATE KEY-----\n",
//   "client_email": "google-sheet-cred@ancient-cortex-494707-k8.iam.gserviceaccount.com",
//   "client_id": "100659189409845015369",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/google-sheet-cred%40ancient-cortex-494707-k8.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// }''';
//   static const String _gsid = '1T-g6_d285V7SAVFlXXUiwGCvzXKVVcCl627jEvTixYM';
//   static final GSheets _gsheets = GSheets(_credentials);
//   static Spreadsheet? spreadsheet;

//   static Future init() async {
//     spreadsheet = await _gsheets.spreadsheet(_gsid);
//   }

//   // SPREADSHEET TITLE
//   static Future<String> title() async {
//     // Spreadsheet spreadsheet = await _spreadsheet();
//     Spreadsheet ss = spreadsheet ?? await _gsheets.spreadsheet(_gsid);
//     return ss.data.properties.title ?? "Title";
//   }

//   // LIST OF WORKSHEET
//   static Future<List<WorksheetModel>> listOfWorksheets() async {
//     Spreadsheet ss = spreadsheet ?? await _gsheets.spreadsheet(_gsid);
//     List<WorksheetModel> sheets = [];
//     for (Worksheet sheet in ss.sheets) {
//       WorksheetModel model = WorksheetModel(
//         spreadsheetId: sheet.spreadsheetId,
//         id: sheet.id.toString(),
//         title: sheet.title,
//         index: sheet.index.toString(),
//         rowCount: sheet.rowCount.toString(),
//         columnCount: sheet.columnCount.toString(),
//       );
//       sheets.add(model);
//     }
//     return sheets;
//   }

//   // ALL SHEET VALUES AS LIST
//   static Future<List<List<String>>> _allValuesList(
//     WorksheetModel worksheet,
//   ) async {
//     Spreadsheet ss = spreadsheet ?? await _gsheets.spreadsheet(_gsid);
//     String title = worksheet.title;
//     List<List<String>> allValuesList =
//         await ss.worksheetByTitle(title)?.values.allRows() ?? [];
//     return allValuesList;
//   }

//   // ALL SHEET VALUES AS JSON LIST
//   static Future<List<Map<String, dynamic>>> valuesAsJsonList(
//     WorksheetModel worksheet,
//   ) async {
//     List<List<String>> values = await _allValuesList(worksheet);
//     return ListToJson(values).result();
//   }
// }
import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';

import '../models/worksheet_model.dart';
import '../tools/list_to_json.dart';

class GsheetsApi {
  static const String _gsid = '1T-g6_d285V7SAVFlXXUiwGCvzXKVVcCl627jEvTixYM';

  static late GSheets _gsheets;

  static Spreadsheet? spreadsheet;

  // INIT
  static Future<void> init() async {
    // LOAD LOCAL JSON FILE
    final credentials = await rootBundle.loadString(
      'assets/credentials/service_account.json',
    );

    // CREATE GSHEETS INSTANCE
    _gsheets = GSheets(credentials);

    // OPEN SPREADSHEET
    spreadsheet = await _gsheets.spreadsheet(_gsid);
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
}
