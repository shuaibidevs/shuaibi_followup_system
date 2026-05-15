class WorksheetModel {
  final String spreadsheetId;
  final String id;
  final String title;
  final String index;
  final String rowCount;
  final String columnCount;

  WorksheetModel({
    required this.spreadsheetId,
    required this.id,
    required this.title,
    required this.index,
    required this.rowCount,
    required this.columnCount,
  });
  WorksheetModel copyWith({
    String? spreadsheetId,
    String? id,
    String? title,
    String? index,
    String? rowCount,
    String? columnCount,
  }) {
    return WorksheetModel(
      spreadsheetId: spreadsheetId ?? this.spreadsheetId,
      id: id ?? this.id,
      title: title ?? this.title,
      index: index ?? this.index,
      rowCount: rowCount ?? this.rowCount,
      columnCount: columnCount ?? this.columnCount,
    );
  }

  Map<String, dynamic> toMap() => {
    'spreadsheetId': spreadsheetId,
    'id': id,
    'title': title,
    'index': index,
    'rowCount': rowCount,
    'columnCount': columnCount,
  };
}
