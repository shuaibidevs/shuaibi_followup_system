import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String materialName;
  final String orderNumber;
  final String sheetTitle;
  final String sheetId;
  final String? comments;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  OrderModel({
    required this.materialName,
    required this.orderNumber,
    required this.sheetTitle,
    required this.sheetId,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });
  OrderModel copyWith({
    String? materialName,
    String? orderNumber,
    String? sheetTitle,
    String? sheetId,
    String? comments,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return OrderModel(
      materialName: materialName ?? this.materialName,
      orderNumber: orderNumber ?? this.orderNumber,
      sheetTitle: sheetTitle ?? this.sheetTitle,
      sheetId: sheetId ?? this.sheetId,
      comments: comments ?? this.comments,
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
      comments: json['comments'] ?? 'comments',
      createdAt: json['createdAt'] ?? 'createdAt',
      updatedAt: json['updatedAt'] ?? 'updatedAt',
    );
  }

  Map<String, dynamic> toJson() => {
    'materialName': materialName,
    'orderNumber': orderNumber,
    'sheetTitle': sheetTitle,
    'sheetId': sheetId,
    'comments': comments,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
