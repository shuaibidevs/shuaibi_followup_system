import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String materialName;
  final String orderNumber;
  final String sheetTitle;
  final String sheetId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  OrderModel({
    required this.materialName,
    required this.orderNumber,
    required this.sheetTitle,
    required this.sheetId,
    required this.createdAt,
    required this.updatedAt,
  });
  OrderModel copyWith({
    String? materialName,
    String? orderNumber,
    String? sheetTitle,
    String? sheetId,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return OrderModel(
      materialName: materialName ?? this.materialName,
      orderNumber: orderNumber ?? this.orderNumber,
      sheetTitle: sheetTitle ?? this.sheetTitle,
      sheetId: sheetId ?? this.sheetId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      materialName: json['materialName'] ?? 'materialName',
      orderNumber: json['orderNumber'] ?? 'orderNumber',
      sheetTitle: json['sheetTitle'] ?? 'sheetTitle',
      sheetId: json['sheetId'] ?? 'sheetId',
      createdAt: json['createdAt'] ?? 'createdAt',
      updatedAt: json['updatedAt'] ?? 'updatedAt',
    );
  }

  Map<String, dynamic> toJson() => {
    'materialName': materialName,
    'orderNumber': orderNumber,
    'sheetTitle': sheetTitle,
    'sheetId': sheetId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
