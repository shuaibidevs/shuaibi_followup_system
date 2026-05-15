import 'package:cloud_firestore/cloud_firestore.dart';

class WorksheetDataModel {
  final String worksheetId;
  final String worksheetTitle;
  final List<Map<String, dynamic>> worksheetData;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const WorksheetDataModel({
    required this.worksheetId,
    required this.worksheetTitle,
    required this.worksheetData,
    required this.createdAt,
    required this.updatedAt,
  });

  WorksheetDataModel.fromJson(Map<String, dynamic> json)
    : this(
        worksheetId: json['worksheetId'] as String? ?? '',
        worksheetTitle: json['worksheetTitle'] as String? ?? '',
        worksheetData:
            (json['worksheetData'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [],
        createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
        updatedAt: json['updatedAt'] as Timestamp? ?? Timestamp.now(),
      );

  WorksheetDataModel copyWith(
    String? worksheetId,
    String? worksheetTitle,
    List<Map<String, dynamic>>? worksheetData,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  ) {
    return WorksheetDataModel(
      worksheetId: worksheetId ?? this.worksheetId,
      worksheetTitle: worksheetTitle ?? this.worksheetTitle,
      worksheetData: worksheetData ?? this.worksheetData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'worksheetId': worksheetId,
    'worksheetTitle': worksheetTitle,
    'worksheetData': worksheetData,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
