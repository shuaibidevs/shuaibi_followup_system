import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'api/gsheets_api.dart';
import 'firebase_options.dart';
import 'pages/home.dart';
import 'services/database_service.dart';
import 'tools/connection.dart';
import 'tools/data_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('table_settings');
  await GsheetsApi.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

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
    );
  }

  Widget _p(DatabaseService databaseService) {
    return DataBuilder.futureBuilder(
      future: Connection.isConnected(),
      builder: (context, snapshot) {
        bool hasInternet = snapshot.data as bool;
        if (hasInternet) {
          return Home(databaseService: databaseService);
        }
        return const Scaffold(body: Center(child: Text('No Internet')));
      },
    );
  }
}
