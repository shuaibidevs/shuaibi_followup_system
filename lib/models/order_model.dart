import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String materialName;
  final String orderNumber;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  OrderModel({
    required this.materialName,
    required this.orderNumber,
    required this.createdAt,
    required this.updatedAt,
  });
  OrderModel copyWith({
    String? materialName,
    String? orderNumber,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return OrderModel(
      materialName: materialName ?? this.materialName,
      orderNumber: orderNumber ?? this.orderNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      materialName: json['materialName'] ?? 'materialName',
      orderNumber: json['orderNumber'] ?? 'orderNumber',
      createdAt: json['createdAt'] ?? 'createdAt',
      updatedAt: json['updatedAt'] ?? 'updatedAt',
    );
  }

  Map<String, dynamic> toJson() => {
    'materialName': materialName,
    'orderNumber': orderNumber,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
