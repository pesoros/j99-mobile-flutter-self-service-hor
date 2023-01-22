// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:j99_mobile_flutter_self_service/utility/variable.dart'
    as variable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SlotPergiList {
  static list(String trip_id_no, String trip_route_id,
      String fleet_registration_id, String type) async {
    String url = dotenv.env['BASE_URL'] + "/seatlist";

    Uri parseUrl = Uri.parse(
      url,
    );
    final response = await http.post(parseUrl, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "trip_id_no": trip_id_no,
      "trip_route_id": trip_route_id,
      "fleet_registration_id": fleet_registration_id,
      "fleet_type_id": type,
      "booking_date": variable.datePergi,
    });
    List<SlotPergi> list = [];

    for (var data in jsonDecode(response.body)["seats"] as List) {
      list.add(SlotPergi.fromJson(data));
    }
    return list;
  }
}

class SlotPergi {
  int pergi_id;
  String pergi_name;
  bool pergi_isAvailable;
  bool pergi_isSeat;

  SlotPergi(
      {this.pergi_id,
      this.pergi_name,
      this.pergi_isAvailable,
      this.pergi_isSeat});

  SlotPergi.fromJson(Map<String, dynamic> json) {
    pergi_id = json['id'];
    pergi_name = json['name'];
    pergi_isAvailable = json['isAvailable'];
    pergi_isSeat = json['isSeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = pergi_id;
    data['name'] = pergi_name;
    data['isAvailable'] = pergi_isAvailable;
    data['isSeat'] = pergi_isSeat;

    return data;
  }
}
