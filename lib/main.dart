import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api/gsheets_api.dart';
import 'firebase_options.dart';
import 'helpers/login_session_helper.dart';
import 'models/login_session_model.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/database_service.dart';
import 'tools/connection.dart';
import 'tools/consts.dart';
import 'tools/data_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(Consts.loginSession);
  gsheetResult = await GsheetsApi.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

String? gsheetResult;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _p(databaseService),
      // home: _p(databaseService),
    );
  }

  Widget _p(DatabaseService databaseService) {
    return DataBuilder.futureBuilder(
      future: Connection.isConnected(),
      builder: (context, snapshot) {
        bool hasInternet = snapshot.data as bool;
        if (hasInternet) {
          LoginSessionModel loginSessionModel =
              LoginSessionHelper.readSession();
          if (loginSessionModel.loggedIn) {
            if (gsheetResult == null) {
              return HomePage(databaseService: databaseService);
            } else {
              return Scaffold(body: Center(child: Text(gsheetResult!)));
            }
          } else {
            return LoginPage(databaseService: databaseService);
          }
          // return loginSessionModel.loggedIn
          //     ? HomePage(databaseService: databaseService)
          //     : LoginPage(databaseService: databaseService);
        }
        return const Scaffold(body: Center(child: Text('No Internet')));
      },
    );
  }
}
