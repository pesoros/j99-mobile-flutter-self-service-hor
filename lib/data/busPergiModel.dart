// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:j99_mobile_flutter_self_service/utility/variable.dart'
    as variable;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BusPergiList {
  static list() async {
    String url = dotenv.env['BASE_URL'] + "/listbus";

    Uri parse_url = Uri.parse(
      url,
    );
    final response = await http.post(parse_url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "berangkat": variable.selectedFromCity.toString(),
      "tujuan": variable.selectedToCity.toString(),
      "tanggal": variable.datePergi,
      "kelas": (variable.selectedKelasArmada == null ||
              variable.selectedKelasArmada == "0")
          ? ""
          : variable.selectedKelasArmada,
    });
    if (jsonDecode(response.body).toString() ==
        "{status: 404, error: 404, messages: {error: Data Not Found}}") {
      return null;
    } else {
      List<BusPergi> list = [];
      for (var data in jsonDecode(response.body) as List) {
        list.add(BusPergi.fromJson(data));
      }
      return list;
    }
  }
}

class BusPergi {
  String pergi_trip_id_no;
  String pergi_trip_route_id;
  String pergi_shedule_id;
  String pergi_pickup_trip_location;
  String pergi_drop_trip_location;
  String pergi_type;
  String pergi_type_class;
  String pergi_image;
  String pergi_fleet_seats;
  String pergi_fleet_registration_id;
  String pergi_price;
  String pergi_duration;
  String pergi_start;
  String pergi_end;
  String pergi_seatPicked;
  int pergi_seatAvail;
  String pergi_resto_id;

  BusPergi({
    this.pergi_trip_id_no,
    this.pergi_trip_route_id,
    this.pergi_shedule_id,
    this.pergi_pickup_trip_location,
    this.pergi_drop_trip_location,
    this.pergi_type,
    this.pergi_image,
    this.pergi_fleet_seats,
    this.pergi_fleet_registration_id,
    this.pergi_price,
    this.pergi_duration,
    this.pergi_start,
    this.pergi_end,
    this.pergi_seatPicked,
    this.pergi_seatAvail,
    this.pergi_resto_id,
  });

  BusPergi.fromJson(Map<String, dynamic> json) {
    pergi_trip_id_no = json['trip_id_no'];
    pergi_trip_route_id = json['trip_route_id'];
    pergi_shedule_id = json['shedule_id'];
    pergi_pickup_trip_location = json['pickup_trip_location'];
    pergi_drop_trip_location = json['drop_trip_location'];
    pergi_type = json['type'];
    pergi_type_class = json['class'];
    pergi_image = json['image'];
    pergi_fleet_seats = json['fleet_seats'];
    pergi_fleet_registration_id = json['fleet_registration_id'];
    pergi_price = json['price'];
    pergi_duration = json['duration'];
    pergi_start = json['start'];
    pergi_end = json['end'];
    pergi_seatPicked = json['seatPicked'];
    pergi_seatAvail = json['seatAvail'];
    pergi_resto_id = json['resto_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id_no'] = pergi_trip_id_no;
    data['trip_route_id'] = pergi_trip_route_id;
    data['shedule_id'] = pergi_shedule_id;
    data['pickup_trip_location'] = pergi_pickup_trip_location;
    data['drop_trip_location'] = pergi_drop_trip_location;
    data['type'] = pergi_type;
    data['class'] = pergi_type_class;
    data['image'] = pergi_image;
    data['fleet_seats'] = pergi_fleet_seats;
    data['fleet_registration_id'] = pergi_fleet_registration_id;
    data['price'] = pergi_price;
    data['duration'] = pergi_duration;
    data['start'] = pergi_start;
    data['end'] = pergi_end;
    data['seatPicked'] = pergi_seatPicked;
    data['seatAvail'] = pergi_seatAvail;
    data['seatAvail'] = pergi_seatAvail;
    data['resto_id'] = pergi_resto_id;
    return data;
  }
}
