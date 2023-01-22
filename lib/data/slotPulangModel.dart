// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:j99_mobile_flutter_self_service/utility/variable.dart'
    as variable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SlotPulangList {
  static list(
    String trip_id_no,
    String trip_route_id,
    String fleet_registration_id,
    String type,
  ) async {
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
      "booking_date": variable.datePulang
    });
    List<SlotPulang> list = [];

    for (var data in jsonDecode(response.body)["seats"] as List) {
      list.add(SlotPulang.fromJson(data));
    }
    return list;
  }
}

class SlotPulang {
  int pulang_id;
  String pulang_name;
  bool pulang_isAvailable;
  bool pulang_isSeat;

  SlotPulang(
      {this.pulang_id,
      this.pulang_name,
      this.pulang_isAvailable,
      this.pulang_isSeat});

  SlotPulang.fromJson(Map<String, dynamic> json) {
    pulang_id = json['id'];
    pulang_name = json['name'];
    pulang_isAvailable = json['isAvailable'];
    pulang_isSeat = json['isSeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = pulang_id;
    data['name'] = pulang_name;
    data['isAvailable'] = pulang_isAvailable;
    data['isSeat'] = pulang_isSeat;

    return data;
  }
}
