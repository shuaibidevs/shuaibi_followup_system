class TableSettingsModel {
  final Map<String, List<String>> filter;

  TableSettingsModel({required this.filter});

  TableSettingsModel copyWith({Map<String, List<String>>? filter}) {
    return TableSettingsModel(filter: filter ?? this.filter);
  }

  Map<String, dynamic> toJson() => {'filter': filter};
}
