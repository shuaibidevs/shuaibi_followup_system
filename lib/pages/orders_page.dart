import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../models/worksheet_data_model.dart';
import '../services/database_service.dart';
import '../tools/data_builder.dart';
import '../widgets/grid_builder.dart';

class OrdersPage extends StatefulWidget {
  final DatabaseService databaseService;
  final QuerySnapshot<WorksheetDataModel>? worksheetData;
  const OrdersPage({
    super.key,
    required this.databaseService,
    required this.worksheetData,
  });

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

String _pickedFilter = 'show all';

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Orders')), body: _body());
  }

  Widget _body() {
    return DataBuilder.streamBuilder(
      stream: widget.databaseService.readOrder(),
      builder: (context, snapshot) {
        List<QueryDocumentSnapshot<OrderModel>> docs =
            snapshot.data!.data!.docs;
        List<OrderModel> orders = _filterMaker(
          docs.map((e) {
            // _read(e.data().sheetId);
            return e.data();
          }).toList(),
        );

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _tabs(),
              SizedBox(height: 20.0),
              orders.isNotEmpty
                  ? GridBuilder.cardGrid(
                    maxCrossAxisExtent: 250.0,
                    childAspectRatio: 3 / 2,
                    children: _list(orders),
                  )
                  : Expanded(child: Center(child: Text('no orders to show!'))),
            ],
          ),
        );
      },
    );
  }

  Future<WorksheetDataModel> _worksheetDataModel(String sheetId) async {
    QuerySnapshot<WorksheetDataModel>? data =
        (await widget.databaseService.readFollowupData().first).data;
    if (data != null) {
      List<QueryDocumentSnapshot<WorksheetDataModel>> docs = data.docs;
      WorksheetDataModel worksheetDataModel =
          docs.firstWhere((element) {
            return element.data().worksheetId == sheetId;
          }).data();

      return worksheetDataModel;
    }
    return Future.error('error lodaing _worksheetDataModel(...)!');
    // print(v.data?.docs);
  }

  List<Widget> _list(List<OrderModel> orders) {
    List<OrderModel> ordersFixed = [];
    for (OrderModel order in orders) {
      QueryDocumentSnapshot<WorksheetDataModel>? snapshot = widget
          .worksheetData
          ?.docs
          .firstWhere(
            (QueryDocumentSnapshot<WorksheetDataModel> worksheetDataModel) =>
                worksheetDataModel.id == order.sheetId,
          );
      WorksheetDataModel? worksheetData = snapshot?.data();
      Map<String, dynamic>? row = worksheetData?.worksheetData.firstWhere(
        (Map<String, dynamic> json) => json['no'] == order.orderNumber,
      );
      if (row != null && row[order.materialName] == 'pending') {
        ordersFixed.add(order);
      }
    }
    return ordersFixed.map((OrderModel order) {
      return _buildCard(order);
    }).toList();
  }

  Widget _buildCard(OrderModel order) {
    BorderRadius borderRadius = BorderRadius.circular(10);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(5.0),
          child: Text(
            "ORDER#: ${order.orderNumber.toUpperCase()}\nMATERIAL: ${order.materialName.toUpperCase()}\nSHEET: ${order.sheetTitle.toUpperCase()}\nCOMMENTS: ${order.comments?.trim() ?? "null"}\nLAST UPDATED: lastUpdated",
          ),
        ),
      ),
    );
  }

  // _orderDetailsCard(OrderModel order) {
  //   String material = order.materialName;
  //   String orderNumber = order.orderNumber;
  //   String id = order.sheetId;
  //   widget.databaseService.readFollowupData().map((
  //     DatabaseResult<QuerySnapshot<WorksheetDataModel>> event,
  //   ) {
  //     WorksheetDataModel worksheetDataModel =
  //         event.data!.docs
  //             .firstWhere(
  //               (QueryDocumentSnapshot<WorksheetDataModel> doc) =>
  //                   doc.data().worksheetId == id,
  //             )
  //             .data();
  //   });
  // }

  Widget _tabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tab('SHOW ALL', () => setState(() => _pickedFilter = 'show all')),
        _tab('BOTTLE', () => setState(() => _pickedFilter = 'bottle')),
        _tab(
          'COATING & FOILING',
          () => setState(() => _pickedFilter = 'coating & foiling'),
        ),
        _tab('CAP', () => setState(() => _pickedFilter = 'cap')),
        _tab('OIL', () => setState(() => _pickedFilter = 'oil')),
        _tab('BOX', () => setState(() => _pickedFilter = 'box')),
        _tab('STICKER', () => setState(() => _pickedFilter = 'sticker')),
      ],
    );
  }

  Widget _tab(String title, VoidCallback onPressed) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.0),
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            foregroundColor:
                _pickedFilter.toLowerCase() == title.toLowerCase()
                    ? null
                    : WidgetStatePropertyAll(Colors.grey),
          ),
          child: Text(title),
        ),
      ),
    );
  }

  List<OrderModel> _filterMaker(List<OrderModel> orders) {
    switch (_pickedFilter) {
      case 'show all':
        return orders;
      case 'bottle':
        return orders.where((element) {
          return element.materialName == 'bottle';
        }).toList();
      case 'coating & foiling':
        return orders.where((element) {
          return element.materialName == 'coating & foiling';
        }).toList();
      case 'cap':
        return orders.where((element) {
          return element.materialName == 'cap';
        }).toList();
      case 'oil':
        return orders.where((element) {
          return element.materialName == 'oil';
        }).toList();
      case 'box':
        return orders.where((element) {
          return element.materialName == 'box';
        }).toList();
      case 'sticker':
        return orders.where((element) {
          return element.materialName == 'sticker';
        }).toList();

      default:
        return orders;
    }
  }
}
