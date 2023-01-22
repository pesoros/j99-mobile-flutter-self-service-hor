// ignore_for_file: non_constant_identifier_names

class UnitTypeModel {
  final String id;
  final String unit_name;

  UnitTypeModel({
    this.id,
    this.unit_name,
  });

  factory UnitTypeModel.fromJson(Map<String, dynamic> json) {
    return UnitTypeModel(
      id: json["id"],
      unit_name: json["unit_name"],
    );
  }

  static List<UnitTypeModel> fromJsonList(List list) {
    return list.map((item) => UnitTypeModel.fromJson(item)).toList();
  }

  @override
  String toString() => unit_name;
}
