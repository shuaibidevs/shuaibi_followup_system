import 'package:flutter/material.dart';
import 'package:shuaibi_followup_system/helpers/login_session_helper.dart';
import 'package:shuaibi_followup_system/main.dart';
import 'package:shuaibi_followup_system/widgets/grid_builder.dart';

import '../services/database_service.dart';
import '../tools/navigate.dart';
import 'followup_sheets_list_page.dart';
import 'orders_page.dart';

class HomePage extends StatefulWidget {
  final DatabaseService databaseService;
  const HomePage({super.key, required this.databaseService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shuaibi FollowUp'),
        actions: [TextButton(onPressed: _logout, child: Text('logout'))],
      ),

      body: _body(),
      // body: GridView.extent(maxCrossAxisExtent: 150, children: _list()),
    );
  }

  Widget _body() {
    return GridBuilder.cardGrid(children: _list());
  }

  List<Widget> _list() => [
    _buildCard(
      title: 'FollowUp Sheets',
      onTap: () {
        Navigate(context).to(
          page: FollowupSheetsListPage(databaseService: widget.databaseService),
        );
      },
    ),
    _buildCard(
      title: 'View Orders',
      onTap: () {
        Navigate(
          context,
        ).to(page: OrdersPage(databaseService: widget.databaseService));
      },
    ),
  ];
  Widget _buildCard({required String title, required VoidCallback? onTap}) {
    BorderRadius borderRadius = BorderRadius.circular(10);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Center(child: Text(title)),
      ),
    );
  }

  void _logout() async {
    bool sessionUpdated = await LoginSessionHelper.updateSession(
      loggedIn: false,
      updatedAt: DateTime.now().toString(),
    );
    if (sessionUpdated) {
      if (mounted) {
        Navigate(context).to(page: MyApp());
        // Navigate(context).back();
      }
    } else {
      print('failed to update the session!');
    }
    // Navigator.pop(context);
  }
}
