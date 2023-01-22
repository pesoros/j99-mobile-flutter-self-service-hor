// ignore_for_file: non_constant_identifier_names, file_names, prefer_collection_literals

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImagePrefix {
  static list() async {
    String url = dotenv.env['BASE_URL'] + "/carousel/phone";

    Uri parse_url = Uri.parse(url);
    final response = await http.get(parse_url);
    return jsonDecode(response.body)['url'];
  }
}

class ImageList {
  static list() async {
    String url = dotenv.env['BASE_URL'] + "/carousel/phone";

    Uri parse_url = Uri.parse(
      url,
    );
    final response = await http.get(parse_url);
    List<ImageModel> list = [];
    for (var data in jsonDecode(response.body)['image'] as List) {
      list.add(ImageModel.fromJson(data));
    }
    return list;
  }
}

class ImageModel {
  String image;

  ImageModel({
    this.image,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = image;

    return data;
  }
}
