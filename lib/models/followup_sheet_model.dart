class FollowupSheetModel {
  final String date;
  final String no;
  final String customer;
  final String brand;
  final String perfume;
  final String quantity;
  final String bottle;
  final String coatingFoiling;
  final String cap;
  final String oil;
  final String box;
  final String sticker;
  final String remarks;
  final String munir;

  FollowupSheetModel({
    required this.date,
    required this.no,
    required this.customer,
    required this.brand,
    required this.perfume,
    required this.quantity,
    required this.bottle,
    required this.coatingFoiling,
    required this.cap,
    required this.oil,
    required this.box,
    required this.sticker,
    required this.remarks,
    required this.munir,
  });
  FollowupSheetModel copyWith({
    String? date,
    String? no,
    String? customer,
    String? brand,
    String? perfume,
    String? quantity,
    String? bottle,
    String? coatingFoiling,
    String? cap,
    String? oil,
    String? box,
    String? sticker,
    String? remarks,
    String? munir,
  }) {
    return FollowupSheetModel(
      date: date ?? this.date,
      no: no ?? this.no,
      customer: customer ?? this.customer,
      brand: brand ?? this.brand,
      perfume: perfume ?? this.perfume,
      quantity: quantity ?? this.quantity,
      bottle: bottle ?? this.bottle,
      coatingFoiling: coatingFoiling ?? this.coatingFoiling,
      cap: cap ?? this.cap,
      oil: oil ?? this.oil,
      box: box ?? this.box,
      sticker: sticker ?? this.sticker,
      remarks: remarks ?? this.remarks,
      munir: munir ?? this.munir,
    );
  }

  factory FollowupSheetModel.fromJson(Map<String, dynamic> json) {
    return FollowupSheetModel(
      date: json['date'] ?? '',
      no: json['no'] ?? '',
      customer: json['customer'] ?? '',
      brand: json['brand'] ?? '',
      perfume: json['perfume'] ?? '',
      quantity: json['quantity'] ?? '',
      bottle: json['bottle'] ?? '',
      coatingFoiling: json['coating & foiling'] ?? '',
      cap: json['cap'] ?? '',
      oil: json['oil'] ?? '',
      box: json['box'] ?? '',
      sticker: json['sticker'] ?? '',
      remarks: json['remarks'] ?? '',
      munir: json['munir'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'date': date,
    'no': no,
    'customer': customer,
    'brand': brand,
    'perfume': perfume,
    'quantity': quantity,
    'bottle': bottle,
    'coating & foiling': coatingFoiling,
    'cap': cap,
    'oil': oil,
    'box': box,
    'sticker': sticker,
    'remarks': remarks,
    'munir': munir,
  };
}
