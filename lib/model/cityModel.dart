// ignore_for_file: file_names, unnecessary_this

class CityModel {
  final String id;
  final String namaKota;

  CityModel({
    this.id,
    this.namaKota,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CityModel(
      id: json["id"],
      namaKota: json["namaKota"],
    );
  }

  static List<CityModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CityModel.fromJson(item)).toList();
  }

  String userAsString() {
    return '#${this.id} ${this.namaKota}';
  }

  bool isEqual(CityModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => namaKota;
}
