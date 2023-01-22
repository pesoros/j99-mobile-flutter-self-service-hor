// ignore_for_file: file_names, unnecessary_this, prefer_collection_literals

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClassModel {
  final String id;
  final String kelas;

  ClassModel({
    this.id,
    this.kelas,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return ClassModel(
      id: json["id"],
      kelas: json["kelas"],
    );
  }

  static List<ClassModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => ClassModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.kelas}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(ClassModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => kelas;
}

class GetClassList {
  static list(
    String type,
  ) async {
    String url = dotenv.env['BASE_URL'] + "/datakelas";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl);
    List<ClassList> list = [];

    for (var data in jsonDecode(response.body) as List) {
      list.add(ClassList.fromJson(data));
    }

    list.removeWhere((item) => item.id != type);
    return list;
  }
}

class ClassList {
  String id;
  String kelas;

  ClassList({
    this.id,
    this.kelas,
  });

  ClassList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kelas = json['kelas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['kelas'] = this.kelas;

    return data;
  }
}
