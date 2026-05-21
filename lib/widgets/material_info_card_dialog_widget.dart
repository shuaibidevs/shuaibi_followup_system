import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/material_info_model.dart';
import '../models/order_model.dart';
import '../services/database_service.dart';
import '../tools/data_builder.dart';
import '../tools/screen_size.dart';

class MaterialInfoCardDialogWidget extends StatefulWidget {
  final Map<String, dynamic> map;
  final String mapKey;
  final DatabaseService databaseService;
  final String tableId;
  final String tableTitle;
  const MaterialInfoCardDialogWidget({
    super.key,
    required this.map,
    required this.mapKey,
    required this.databaseService,
    required this.tableTitle,
    required this.tableId,
  });

  @override
  State<MaterialInfoCardDialogWidget> createState() =>
      _MaterialInfoCardDialogWidgetState();
}

String _feedback = '';
bool _showExtraCard = false;

class _MaterialInfoCardDialogWidgetState
    extends State<MaterialInfoCardDialogWidget> {
  final TextEditingController _codeCtrl = TextEditingController();
  final TextEditingController _supplierCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  final TextEditingController _commentCtrl = TextEditingController();
  Stream<DatabaseResult<QuerySnapshot<MaterialInfoModel>>>? _stream;
  bool _editEnabled = false;
  bool _canApply = false;
  int _page = 0;
  @override
  void initState() {
    _stream = widget.databaseService.readMaterialData();
    _initCtrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataBuilder.streamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        QuerySnapshot<MaterialInfoModel> data = snapshot.data!.data!;
        List<MaterialInfoModel> docs =
            data.docs.map((
              QueryDocumentSnapshot<MaterialInfoModel> docSnapshot,
            ) {
              return docSnapshot.data();
            }).toList();

        MaterialInfoModel materialInfo = docs.firstWhere(
          (MaterialInfoModel materialInfo) =>
              materialInfo.orderNumber == widget.map['no'] &&
              materialInfo.itemName == widget.mapKey,
          orElse:
              () => MaterialInfoModel(
                code: 'Unavailable',
                supplier: 'Unavailable',
                imageUrl: 'null',
                description: 'Unavailable',
                orderNumber: 'Unavailable',
                itemName: 'Unavailable',
                sheetId: 'Unavailable',
                createdAt: Timestamp.now(),
                updatedAt: Timestamp.now(),
              ),
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _page0(materialInfo),
            _page1(materialInfo),
            Text(_feedback),
          ],
        );
      },
    );
  }

  Widget _page1(MaterialInfoModel materialInfo) {
    return _page != 1
        ? SizedBox.shrink()
        : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Card(child: _btf(_commentCtrl))),
            Flexible(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // _commentCtrl.clear();
                        _page = 0;
                      });
                    },
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      _sendRequest(materialInfo);
                    },
                    child: Text('SEND'),
                  ),
                ],
              ),
            ),
          ],
        );
  }

  Widget _page0(MaterialInfoModel materialInfo) {
    return _page != 0
        ? SizedBox.shrink()
        : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: _materialImg(materialInfo.imageUrl),
                          ),
                        ),
                        // SizedBox(width: 30.0),
                        Expanded(
                          child: Container(
                            // color: Colors.amber,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Code',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _tf(materialInfo.code, _codeCtrl),
                                const SizedBox(height: 10.0),
                                Text(
                                  'Supplier',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _tf(materialInfo.supplier, _supplierCtrl),
                                const SizedBox(height: 10.0),
                                Text(
                                  'Description',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _tf(materialInfo.description, _descriptionCtrl),
                                const Divider(),
                                Text(
                                  'Order#',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(widget.map['no']),
                                const SizedBox(height: 10.0),
                                Text(
                                  'Status',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(widget.map[widget.mapKey]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.map[widget.mapKey] != 'done') _extraCard(),
                    if (widget.map[widget.mapKey] != 'done')
                      TextButton(
                        onPressed: () {
                          if (widget.map[widget.mapKey] == 'pending') {
                            setState(() {
                              _page = 1;
                            });
                          }
                          // setState(() {
                          //   _showExtraCard = !_showExtraCard;
                          // });
                          // _sendRequest(materialInfo);
                        },
                        child: Text(
                          widget.map[widget.mapKey] == 'pending'
                              ? 'Send Order Request'
                              : 'Send Update Request',
                        ),
                      ),
                  ],
                ),
              ),
            ),
            _actions(),
          ],
        );
  }

  Widget _tf(String value, TextEditingController? controller) {
    return TextField(
      enabled: _editEnabled,
      controller: controller,
      onChanged: (String value) {
        if (value.trim().isNotEmpty && !_canApply) {
          setState(() {
            _canApply = true;
          });
        } else if (_codeCtrl.text.trim().isEmpty &&
            _supplierCtrl.text.trim().isEmpty &&
            _descriptionCtrl.text.trim().isEmpty) {
          setState(() {
            _canApply = false;
          });
        }
      },
      decoration: InputDecoration(
        hintText: value,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
        hintStyle: TextStyle(color: Colors.black),
      ),
      style: TextStyle(fontSize: 14.0),
      maxLines: null,
    );
  }

  Widget _btf(TextEditingController? controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        onChanged: (String value) {
          if (value.trim().isNotEmpty && !_canApply) {
            setState(() {
              _canApply = true;
            });
          } else if (_codeCtrl.text.trim().isEmpty &&
              _supplierCtrl.text.trim().isEmpty &&
              _descriptionCtrl.text.trim().isEmpty) {
            setState(() {
              _canApply = false;
            });
          }
        },
        decoration: InputDecoration(
          hintText: 'Write comments',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          // hintStyle: TextStyle(color: Colors.black),
        ),
        style: TextStyle(fontSize: 14.0),
        maxLines: 10,
      ),
    );
  }

  Widget _materialImg(String imageUrl) {
    if (imageUrl == 'null') {
      return SvgPicture.asset(
        'assets/no_img.svg',
        width: ScreenSize.width * .1,
        height: ScreenSize.width * .1,
        fit: BoxFit.cover,
      );
    }
    return SvgPicture.network(imageUrl);
  }

  Widget _actions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_editEnabled)
              TextButton(onPressed: _cancel, child: Text('Cancel')),
            if (_editEnabled)
              TextButton(onPressed: () {}, child: Text('Copy from existing')),
            SizedBox(width: 10.0),
            TextButton(
              onPressed:
                  _editEnabled
                      ? _canApply
                          ? _addMaterialToDb
                          : null
                      : _edit,
              child: Text(_editEnabled ? 'Apply' : 'Edit'),
            ),
          ],
        ),
      ],
    );
  }

  _edit() {
    setState(() {
      _editEnabled = true;
    });
  }

  _cancel() {
    setState(() {
      _editEnabled = false;
      _initCtrl();
    });
  }

  _addMaterialToDb() {
    widget.databaseService
        .createMaterialData(
          MaterialInfoModel(
            code: _codeCtrl.text.trim(),
            supplier: _supplierCtrl.text.trim(),
            imageUrl: 'null',
            description: _descriptionCtrl.text.trim(),
            orderNumber: widget.map['no'],
            itemName: widget.mapKey,
            sheetId: widget.tableId,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
          ),
        )
        .then((value) {
          if (value.isSuccess) {
            // CREATE SNACKBAR FEEDBACK
            if (mounted) Navigator.pop(context);
          } else {
            // CREATE SNACKBAR FEEDBACK
          }
        });
  }

  _sendRequest(MaterialInfoModel materialInfoModel) {
    if (widget.map[widget.mapKey] == 'pending') {
      widget.databaseService.readOrder().first.then((value) {
        QuerySnapshot<OrderModel>? data = value.data;
        if (data == null) {
          _createOrder(materialInfoModel);
        } else {
          bool exists = data.docs
              .map((query) => query.data())
              .any(
                (order) =>
                    order.materialName == widget.mapKey &&
                    order.orderNumber == widget.map['no'],
              );
          if (!exists) {
            _createOrder(materialInfoModel);
          } else {
            setState(() {
              _feedback = 'order already exists!';
            });
          }
        }
      });
    } else {
      // 'not pending: send update request'
    }
  }

  _createOrder(MaterialInfoModel materialInfoModel) {
    widget.databaseService
        .createOrder(
          OrderModel(
            materialName: widget.mapKey,
            orderNumber: widget.map['no'],
            sheetTitle: widget.tableTitle,
            sheetId: widget.tableId,
            comments: _commentCtrl.text.trim(),
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
          ),
        )
        .then((value) async {
          if (value.isSuccess) {
            setState(() {
              _feedback = 'order request was sent successfully';
            });
          } else {
            setState(() {
              _feedback = 'failed to send order request';
            });
          }
        });
  }

  _initCtrl() {
    _codeCtrl.clear();
    _supplierCtrl.clear();
    _descriptionCtrl.clear();
    _feedback = '';
  }

  _extraCard() {
    return _showExtraCard
        ? Card(child: Center(child: Text('extra card')))
        : SizedBox.shrink();
  }
}
