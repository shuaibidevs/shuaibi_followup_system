import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api/gsheets_api.dart';
import 'firebase_options.dart';
import 'models/worksheet_data_model.dart';
import 'pages/home_page.dart';
import 'pages/login2_page.dart';
import 'services/database_service.dart';
import 'tools/connection.dart';
import 'tools/data_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // await Hive.openBox(Consts.loginSession);
  gsheetResult = await GsheetsApi.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

String? gsheetResult;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  bool get isMobileBrowser {
    if (!kIsWeb) return false;

    final width =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return width < 768;
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _p2(databaseService),
      // home: _p(databaseService),
    );
  }

  // Widget _p(DatabaseService databaseService) {
  //   return DataBuilder.futureBuilder(
  //     future: Connection.isConnected(),
  //     builder: (context, snapshot) {
  //       bool hasInternet = snapshot.data as bool;
  //       if (hasInternet) {
  //         LoginSessionModel loginSessionModel =
  //             LoginSessionHelper.readSession();
  //         if (loginSessionModel.loggedIn) {
  //           if (gsheetResult == null) {
  //             return DataBuilder.streamBuilder(
  //               stream: databaseService.readFollowupData(),
  //               builder: (context, snapshot) {
  //                 QuerySnapshot<WorksheetDataModel>? data = snapshot.data!.data;

  //                 return HomePage(
  //                   databaseService: databaseService,
  //                   worksheetData: data,
  //                 );
  //               },
  //             );
  //           } else {
  //             return Scaffold(body: Center(child: Text(gsheetResult!)));
  //           }
  //         } else {
  //           return LoginPage(databaseService: databaseService);
  //         }
  //         // return loginSessionModel.loggedIn
  //         //     ? HomePage(databaseService: databaseService)
  //         //     : LoginPage(databaseService: databaseService);
  //       }
  //       return const Scaffold(body: Center(child: Text('No Internet')));
  //     },
  //   );
  // }

  Widget _p2(DatabaseService databaseService) {
    return DataBuilder.futureBuilder(
      future: Connection.isConnected(),
      builder: (context, snapshot) {
        bool hasInternet = snapshot.data as bool;
        if (hasInternet) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                if (gsheetResult == null) {
                  return DataBuilder.streamBuilder(
                    stream: databaseService.readFollowupData(),
                    builder: (cx2, snapshot) {
                      QuerySnapshot<WorksheetDataModel>? data =
                          snapshot.data!.data;

                      return HomePage(
                        databaseService: databaseService,
                        worksheetData: data,
                      );
                    },
                  );
                } else {
                  return Scaffold(body: Center(child: Text(gsheetResult!)));
                } // user is logged in
              }
              return Login2Page(); // user is not logged in
            },
          );
        }
        return const Scaffold(body: Center(child: Text('No Internet')));
      },
    );
  }
}
