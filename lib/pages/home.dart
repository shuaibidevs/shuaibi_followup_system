import 'package:flutter/material.dart';
import 'package:shuaibi_followup_system/widgets/grid_builder.dart';

import '../services/database_service.dart';
import '../tools/navigate.dart';
import 'followup_sheets_list.dart';

class Home extends StatefulWidget {
  final DatabaseService databaseService;
  const Home({super.key, required this.databaseService});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shuaibi FollowUp')),

      body: _body(),
      // body: GridView.extent(maxCrossAxisExtent: 150, children: _list()),
    );
  }

  Widget _body() {
    return GridBuilder.cardGrid(children: _list());
  }

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

  List<Widget> _list() => [
    _buildCard(
      title: 'FollowUp Sheets',
      onTap: () {
        Navigate(
          context,
        ).to(page: FollowupSheetsList(databaseService: widget.databaseService));
      },
    ),
  ];
}
