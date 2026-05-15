import 'package:hive_flutter/hive_flutter.dart';

import '../models/table_settings_model.dart';

class TableSettingsHelper {
  static const String _boxName = 'table_settings';
  final String tableId;
  TableSettingsHelper({required this.tableId});

  Future<void> save(TableSettingsModel tableSettingsModel) async {
    var box = Hive.box(_boxName);
    await box.put(tableId, tableSettingsModel.toJson());
  }

  Map<String, dynamic> read() {
    var box = Hive.box(_boxName);
    final data = box.get(tableId);
    if (data == null) return TableSettingsModel(filter: {}).toJson();

    return Map<String, dynamic>.from(data);
  }

  clearSettings() async {
    await Hive.box(_boxName).delete(tableId);
  }

  bool exists() {
    var box = Hive.box(_boxName);
    return box.containsKey(tableId);
  }
}
