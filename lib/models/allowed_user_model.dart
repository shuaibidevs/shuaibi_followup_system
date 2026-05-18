import 'package:cloud_firestore/cloud_firestore.dart';

class AllowedUserModel {
  final String email;
  final String password;
  final String type;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  AllowedUserModel({
    required this.email,
    required this.password,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  AllowedUserModel copyWith({
    String? email,
    String? password,
    String? type,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return AllowedUserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AllowedUserModel.fromJson(Map<String, dynamic> json) {
    return AllowedUserModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'type': type,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
