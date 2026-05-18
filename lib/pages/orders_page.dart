import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shuaibi_followup_system/api/gsheets_api.dart';

import '../models/order_model.dart';
import '../models/worksheet_data_model.dart';
import '../services/database_service.dart';
import '../tools/data_builder.dart';
import '../widgets/grid_builder.dart';

class OrdersPage extends StatefulWidget {
  final DatabaseService databaseService;
  const OrdersPage({super.key, required this.databaseService});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

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
        List<OrderModel> orders = docs.map((e) => e.data()).toList();
        return orders.isNotEmpty
            ? GridBuilder.cardGrid(children: _list(orders))
            : Text('no orders to show!');
      },
    );
  }

  List<Widget> _list(List<OrderModel> orders) {
    return orders.map((OrderModel order) {
      return _buildCard(order);
    }).toList();
  }

  Widget _buildCard(OrderModel order) {
    BorderRadius borderRadius = BorderRadius.circular(10);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {},
        child: Center(
          child: Text(
            "ORDER#: ${order.orderNumber.toUpperCase()}\nMATERIAL: ${order.materialName.toUpperCase()}\nSHEET: ${order.sheetTitle.toUpperCase()}",
          ),
        ),
      ),
    );
  }

  _orderDetailsCard(OrderModel order) {
    String material = order.materialName;
    String orderNumber = order.orderNumber;
    String id = order.sheetId;
    widget.databaseService.readFollowupData().map((
      DatabaseResult<QuerySnapshot<WorksheetDataModel>> event,
    ) {
      WorksheetDataModel worksheetDataModel =
          event.data!.docs
              .firstWhere(
                (QueryDocumentSnapshot<WorksheetDataModel> doc) =>
                    doc.data().worksheetId == id,
              )
              .data();
    });
  }
}
