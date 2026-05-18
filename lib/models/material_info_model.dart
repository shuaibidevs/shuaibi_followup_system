import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialInfoModel {
  final String code;
  final String supplier;
  final String imageUrl;
  final String description;
  final String orderNumber;
  final String itemName;
  final String sheetId;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  MaterialInfoModel({
    required this.code,
    required this.supplier,
    required this.imageUrl,
    required this.description,
    required this.orderNumber,
    required this.itemName,
    required this.sheetId,
    required this.createdAt,
    required this.updatedAt,
  });
  MaterialInfoModel copyWith({
    String? code,
    String? supplier,
    String? imageUrl,
    String? description,
    String? orderNumber,
    String? itemName,
    String? sheetId,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return MaterialInfoModel(
      code: code ?? this.code,
      supplier: supplier ?? this.supplier,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      orderNumber: orderNumber ?? this.orderNumber,
      itemName: itemName ?? this.itemName,
      sheetId: sheetId ?? this.sheetId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MaterialInfoModel.fromJson(Map<String, dynamic> json) {
    return MaterialInfoModel(
      code: json['code'] ?? 'code',
      supplier: json['supplier'] ?? 'supplier',
      imageUrl: json['imageUrl'] ?? 'imageUrl',
      description: json['description'] ?? 'description',
      orderNumber: json['orderNumber'] ?? 'orderNumber',
      itemName: json['itemName'] ?? 'itemName',
      sheetId: json['sheetId'] ?? 'sheetId',
      createdAt: json['createdAt'] ?? 'createdAt',
      updatedAt: json['updatedAt'] ?? 'updatedAt',
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'supplier': supplier,
    'imageUrl': imageUrl,
    'description': description,
    'orderNumber': orderNumber,
    'itemName': itemName,
    'sheetId': sheetId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
