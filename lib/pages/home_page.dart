import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shuaibi_followup_system/services/auth_service.dart';
// ONLY FOR FLUTTER WEB
import 'package:web/web.dart' as web;

import '../models/worksheet_data_model.dart';
import '../services/database_service.dart';
import '../tools/navigate.dart';
import '../widgets/grid_builder.dart';
import 'followup_sheets_list_page.dart';
import 'orders_page.dart';

class HomePage extends StatefulWidget {
  final DatabaseService databaseService;
  final QuerySnapshot<WorksheetDataModel>? worksheetData;
  const HomePage({
    super.key,
    required this.databaseService,
    required this.worksheetData,
  });

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
          page: FollowupSheetsListPage(
            databaseService: widget.databaseService,
            worksheetData: widget.worksheetData,
          ),
        );
      },
    ),
    _buildCard(
      title: 'View Orders',
      onTap: () {
        Navigate(context).to(
          page: OrdersPage(
            databaseService: widget.databaseService,
            worksheetData: widget.worksheetData,
          ),
        );
      },
    ),
    _buildCard(
      title: 'PDF VIEWR (TEST PAGE)',
      onTap: () {
        // Navigate(context).to(
        //   page: PdfViewerWidget(
        //     pdfUrl:
        //         'https://alshuaibiperfumesuea-my.sharepoint.com/:b:/g/personal/user1_alshuaibiperfumesuea_onmicrosoft_com/IQDr77eqebVNQ7ziMBcNtDorAXWJomjNdnaeey_48f_FBQU?e=NzenjI',
        //   ),
        // );
        openPdf(
          'https://alshuaibiperfumesuea-my.sharepoint.com/:b:/g/personal/user1_alshuaibiperfumesuea_onmicrosoft_com/IQDr77eqebVNQ7ziMBcNtDorAXWJomjNdnaeey_48f_FBQU?e=NzenjI',
        );
      },
    ),
  ];
  void openPdf(String pdfUrl) {
    web.window.open(pdfUrl, '_blank');
  }

  Widget _buildCard({required String title, required VoidCallback? onTap}) {
    BorderRadius borderRadius = BorderRadius.circular(10);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Center(child: Text(title, textAlign: TextAlign.center)),
      ),
    );
  }

  _logout() {
    AuthService().logout();
  }
}
