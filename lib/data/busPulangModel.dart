// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:j99_mobile_flutter_self_service/utility/variable.dart'
    as variable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BusPulangList {
  static list() async {
    String url = dotenv.env['BASE_URL'] + "/listbus";

    Uri parse_url = Uri.parse(
      url,
    );
    final response = await http.post(parse_url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "berangkat": variable.selectedToCity.toString(),
      "tujuan": variable.selectedFromCity.toString(),
      "tanggal": variable.datePulang,
      "kelas": (variable.selectedKelasArmada == null ||
              variable.selectedKelasArmada == "0")
          ? ""
          : variable.selectedKelasArmada,
    });

    if (jsonDecode(response.body).toString() ==
        "{status: 404, error: 404, messages: {error: Data Not Found}}") {
      return null;
    } else {
      List<BusPulang> list = [];
      for (var data in jsonDecode(response.body) as List) {
        list.add(BusPulang.fromJson(data));
      }
      return list;
    }
  }
}

class BusPulang {
  String pulang_trip_id_no;
  String pulang_trip_route_id;
  String pulang_shedule_id;
  String pulang_pickup_trip_location;
  String pulang_drop_trip_location;
  String pulang_type;
  String pulang_type_class;
  String pulang_image;
  String pulang_fleet_seats;
  String pulang_fleet_registration_id;
  String pulang_price;
  String pulang_duration;
  String pulang_start;
  String pulang_end;
  String pulang_seatPicked;
  int pulang_seatAvail;
  String pulang_resto_id;

  BusPulang({
    this.pulang_trip_id_no,
    this.pulang_trip_route_id,
    this.pulang_shedule_id,
    this.pulang_pickup_trip_location,
    this.pulang_drop_trip_location,
    this.pulang_type,
    this.pulang_type_class,
    this.pulang_image,
    this.pulang_fleet_seats,
    this.pulang_fleet_registration_id,
    this.pulang_price,
    this.pulang_duration,
    this.pulang_start,
    this.pulang_end,
    this.pulang_seatPicked,
    this.pulang_seatAvail,
    this.pulang_resto_id,
  });

  BusPulang.fromJson(Map<String, dynamic> json) {
    pulang_trip_id_no = json['trip_id_no'];
    pulang_trip_route_id = json['trip_route_id'];
    pulang_shedule_id = json['shedule_id'];
    pulang_pickup_trip_location = json['pickup_trip_location'];
    pulang_drop_trip_location = json['drop_trip_location'];
    pulang_type = json['type'];
    pulang_type_class = json['class'];
    pulang_image = json['image'];
    pulang_fleet_seats = json['fleet_seats'];
    pulang_fleet_registration_id = json['fleet_registration_id'];
    pulang_price = json['price'];
    pulang_duration = json['duration'];
    pulang_start = json['start'];
    pulang_end = json['end'];
    pulang_seatPicked = json['seatPicked'];
    pulang_seatAvail = json['seatAvail'];
    pulang_resto_id = json['resto_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id_no'] = pulang_trip_id_no;
    data['trip_route_id'] = pulang_trip_route_id;
    data['shedule_id'] = pulang_shedule_id;
    data['pickup_trip_location'] = pulang_pickup_trip_location;
    data['drop_trip_location'] = pulang_drop_trip_location;
    data['type'] = pulang_type;
    data['class'] = pulang_type_class;
    data['image'] = pulang_image;
    data['fleet_seats'] = pulang_fleet_seats;
    data['fleet_registration_id'] = pulang_fleet_registration_id;
    data['price'] = pulang_price;
    data['duration'] = pulang_duration;
    data['start'] = pulang_start;
    data['end'] = pulang_end;
    data['seatPicked'] = pulang_seatPicked;
    data['seatAvail'] = pulang_seatAvail;
    data['seatAvail'] = pulang_seatAvail;
    data['resto_id'] = pulang_resto_id;
    return data;
  }
}
