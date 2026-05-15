// ALL SHEET VALUES LIST AS JSON LIST
class ListToJson {
  final List<List<String>> list;
  ListToJson(this.list);

  List<Map<String, dynamic>> result() {
    if (list.isEmpty) {
      return [];
    }
    List<String> headers = list.first;
    List<Map<String, dynamic>> jsonList = [];
    for (int i = 1; i < list.length; i++) {
      List<String> row = list[i];
      Map<String, String> jsonRow = {};
      for (int j = 0; j < headers.length; j++) {
        String key = headers[j].toLowerCase();
        String value = j < row.length ? row[j].toLowerCase() : '';
        if (key.contains('date') && value.trim().isEmpty) {
          break;
        } else if (key.contains('date')) {
          value =
              _d(
                value.trim().isEmpty ? 0 : int.tryParse(value) ?? 0,
              ).toString();
        }
        jsonRow[key] = value;
      }
      if (jsonRow.isNotEmpty) jsonList.add(jsonRow);
    }

    return jsonList;
  }

  String _d(int days) {
    return DateTime(
      1899,
      12,
      30,
    ).add(Duration(days: days)).toString().substring(0, 10);
  }
}
