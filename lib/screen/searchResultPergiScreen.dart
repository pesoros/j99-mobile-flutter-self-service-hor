// ignore_for_file: unused_import, unused_local_variable, non_constant_identifier_names, unused_element, use_key_in_widget_constructors, unused_field

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:indonesia/indonesia.dart';
import 'package:j99_mobile_flutter_self_service/data/busPergiModel.dart';
import 'package:j99_mobile_flutter_self_service/data/cityModel.dart';
import 'package:j99_mobile_flutter_self_service/data/classModel.dart';
import 'package:j99_mobile_flutter_self_service/data/slotPergiModel.dart';
import 'package:j99_mobile_flutter_self_service/data/unitTypeModel.dart';
import 'package:j99_mobile_flutter_self_service/utility/color.dart';
import 'package:j99_mobile_flutter_self_service/utility/dimension.dart';

import 'package:j99_mobile_flutter_self_service/utility/variable.dart'
    as variable;

class SearchResultPergiScreen extends StatefulWidget {
  @override
  _SearchResultPergiScreenState createState() =>
      _SearchResultPergiScreenState();
}

class _SearchResultPergiScreenState extends State<SearchResultPergiScreen> {
  double bottomPadding = 0;
  List<BusPergi> _listBus = [];
  DateTime tempDate = DateFormat("yyyy-MM-dd").parse(variable.datePergi);

  bool isLoading = true;
  bool busNotAvailable = false;

  @override
  void initState() {
    super.initState();
    getBusList();
  }

  getBusList() async {
    await BusPergiList.list().then((value) {
      if (value != null) {
        setState(() {
          _listBus = value;
          isLoading = false;
          busNotAvailable = false;
          tempDate = DateFormat("yyyy-MM-dd").parse(variable.datePergi);
        });
      } else {
        setState(() {
          isLoading = false;
          busNotAvailable = true;
          tempDate = DateFormat("yyyy-MM-dd").parse(variable.datePergi);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              headerWidget(context),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : busNotAvailable
                      ? Center(child: Text("Bus tidak tersedia."))
                      : bodyWidget(context),
              filterWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  headerWidget(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24)),
          color: CustomColor.darkGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: Stack(
                      children: [
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: CustomColor.white,
                              size: Dimensions.defaultTextSize,
                            ),
                          ),
                          onTap: () {
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => DashboardScreen(0)),
                            //   (Route<dynamic> route) => false,
                            // );
                          },
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hasil Pencarian",
                                  style: TextStyle(
                                      color: CustomColor.white,
                                      fontSize: Dimensions.defaultTextSize,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ))
                      ],
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        variable.selectedFromCity.toString(),
                        style: TextStyle(
                            color: CustomColor.grey,
                            fontSize: Dimensions.defaultTextSize),
                      ),
                    ),
                    DottedLine(
                      direction: Axis.horizontal,
                      lineLength: MediaQuery.of(context).size.width / 5,
                      lineThickness: 1.0,
                      dashLength: 5.0,
                      dashColor: CustomColor.white,
                      dashGapLength: 5.0,
                      dashGapColor: Colors.transparent,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(
                        variable.selectedToCity.toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: CustomColor.grey,
                            fontSize: Dimensions.defaultTextSize),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Text(
                      tanggal(tempDate, shortMonth: true),
                      style: TextStyle(
                          fontSize: Dimensions.defaultTextSize,
                          color: CustomColor.white),
                    ),
                  ),
                  (variable.checkPulangPergi == true)
                      ? Container(
                          margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                          child: Text(
                            "Tiket Pergi",
                            style: TextStyle(
                                fontSize: Dimensions.defaultTextSize,
                                color: CustomColor.white),
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ));
  }

  filterWidget(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: GestureDetector(
        child: Container(
          height: 40,
          width: 100,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: CustomColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 10,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.settings,
                  size: Dimensions.defaultTextSize,
                  color: CustomColor.grey,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Filter",
                  style: TextStyle(color: CustomColor.grey),
                ),
              ]),
            ],
          ),
        ),
        onTap: () {
          _navigateFilterScreen(context);
        },
      ),
    );
  }

  bodyWidget(BuildContext context) {
    if (variable.pergi_sort_by == "Harga Terendah") {
      _listBus.sort((min, max) => min.pergi_price.compareTo(max.pergi_price));
    }
    if (variable.pergi_sort_by == "Harga Tertinggi") {
      _listBus.sort((min, max) => max.pergi_price.compareTo(min.pergi_price));
    }
    if (variable.pergi_sort_by == "Keberangkatan Awal") {
      _listBus.sort((min, max) => min.pergi_start.compareTo(max.pergi_start));
    }
    if (variable.pergi_sort_by == "Keberangkatan Akhir") {
      _listBus.sort((min, max) => max.pergi_start.compareTo(min.pergi_start));
    }
    if (variable.pergi_sort_by == "Kedatangan Awal") {
      _listBus.sort((min, max) => min.pergi_end.compareTo(max.pergi_end));
    }
    if (variable.pergi_sort_by == "Kedatangan Akhir") {
      _listBus.sort((min, max) => max.pergi_end.compareTo(min.pergi_end));
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 180,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _listBus.length,
          itemBuilder: (context, index) {
            BusPergi bus = _listBus[index];
            if (index == (_listBus.length - 1)) {
              bottomPadding = 70;
            } else {
              bottomPadding = Dimensions.heightSize * 1;
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: bottomPadding,
                left: Dimensions.marginSize,
                right: Dimensions.marginSize,
              ),
              child: BusTicketPergiWidget(
                bus: bus,
                trip_id_no: bus.pergi_trip_id_no,
                trip_route_id: bus.pergi_trip_route_id,
                shedule_id: bus.pergi_shedule_id,
                pickup_trip_location: bus.pergi_pickup_trip_location,
                drop_trip_location: bus.pergi_drop_trip_location,
                type: bus.pergi_type,
                type_class: bus.pergi_type_class,
                image: bus.pergi_image,
                fleet_seats: bus.pergi_fleet_seats,
                fleet_registration_id: bus.pergi_fleet_seats,
                price: bus.pergi_price,
                duration: bus.pergi_duration,
                start: bus.pergi_start,
                end: bus.pergi_end,
                seatPicked: bus.pergi_seatPicked,
                seatAvail: bus.pergi_seatAvail,
                resto_id: bus.pergi_resto_id,
              ),
            );
          },
        ),
      ),
    );
  }

  _navigateFilterScreen(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 300),
          opaque: false,
          pageBuilder: (_, __, ___) => FilterPergiScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          }),
    );
    getBusList();
    setState(() {});
  }
}

class BusTicketPergiWidget extends StatefulWidget {
  final BusPergi bus;
  final String trip_id_no;
  final String trip_route_id;
  final String shedule_id;
  final String trip_route_name;
  final String pickup_trip_location;
  final String drop_trip_location;
  final String type;
  final String type_class;
  final String image;
  final String fleet_seats;
  final String fleet_registration_id;
  final String price;
  final String duration;
  final String start;
  final String end;
  final String seatPicked;
  final int seatAvail;
  final String resto_id;

  BusTicketPergiWidget({
    this.bus,
    this.trip_id_no,
    this.trip_route_id,
    this.shedule_id,
    this.trip_route_name,
    this.pickup_trip_location,
    this.drop_trip_location,
    this.type,
    this.type_class,
    this.image,
    this.fleet_seats,
    this.fleet_registration_id,
    this.price,
    this.duration,
    this.start,
    this.end,
    this.seatPicked,
    this.seatAvail,
    this.resto_id,
  });

  @override
  _BusTicketPergiWidgetState createState() => _BusTicketPergiWidgetState();
}

class _BusTicketPergiWidgetState extends State<BusTicketPergiWidget> {
  BusPergi bus;

  bool jamLewat = false;

  @override
  void initState() {
    super.initState();
    String dateNowS = variable.datePergi + " " + widget.bus.pergi_start;
    DateTime tempDate = DateTime.parse(dateNowS);
    DateTime nowDate = DateTime.now();

    if (tempDate.isBefore(nowDate)) {
      setState(() {
        jamLewat = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.black12, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ticketBody(context),
          ],
        ),
      ),
    );
  }

  _ticketBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.bus.pergi_type_class,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.defaultTextSize),
            ),
            Row(
              children: [
                Text(
                  "Sisa Kursi: ",
                  style: TextStyle(
                      color: CustomColor.darkGrey,
                      fontSize: Dimensions.smallTextSize),
                ),
                Text(
                  widget.bus.pergi_seatAvail.toString(),
                  style: TextStyle(
                      color: CustomColor.red,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.smallTextSize),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bus.pergi_start + ": ",
                style: TextStyle(
                    color: CustomColor.grey,
                    fontSize: Dimensions.defaultTextSize)),
            Text(widget.pickup_trip_location,
                style: TextStyle(
                    color: CustomColor.grey,
                    fontSize: Dimensions.defaultTextSize)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.duration,
                style: TextStyle(
                    color: CustomColor.grey,
                    fontSize: Dimensions.smallTextSize)),
            SizedBox(width: 10),
            DottedLine(
              direction: Axis.vertical,
              lineLength: 20,
              lineThickness: 1,
              dashColor: CustomColor.grey,
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.bus.pergi_end + ": ",
                style: TextStyle(
                    color: CustomColor.grey,
                    fontSize: Dimensions.defaultTextSize)),
            Text(widget.drop_trip_location,
                style: TextStyle(
                    color: CustomColor.grey,
                    fontSize: Dimensions.defaultTextSize)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  rupiah(widget.bus.pergi_price),
                  style: TextStyle(
                      color: CustomColor.red,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.defaultTextSize),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: CustomColor.darkGrey,
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(
                      Icons.event_seat,
                      color: CustomColor.white,
                      size: Dimensions.defaultTextSize,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 300),
                          opaque: false,
                          pageBuilder: (_, __, ___) =>
                              BusDetailModalPergiWidget(
                                bus: widget.bus,
                                type: widget.bus.pergi_type,
                                type_class: widget.bus.pergi_type_class,
                                image: widget.bus.pergi_image,
                                price: widget.bus.pergi_price,
                                start: widget.bus.pergi_start,
                                end: widget.bus.pergi_end,
                                pickup_trip_location:
                                    widget.bus.pergi_pickup_trip_location,
                                drop_trip_location:
                                    widget.bus.pergi_drop_trip_location,
                                seatAvail: widget.bus.pergi_seatAvail,
                                fleet_registration_id:
                                    widget.bus.pergi_fleet_registration_id,
                                trip_id_no: widget.bus.pergi_trip_id_no,
                                trip_route_id: widget.bus.pergi_trip_route_id,
                              ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end);
                            final curvedAnimation = CurvedAnimation(
                              parent: animation,
                              curve: curve,
                            );

                            return SlideTransition(
                              position: tween.animate(curvedAnimation),
                              child: child,
                            );
                          }),
                    );
                  },
                ),
                SizedBox(width: 10),
                (widget.bus.pergi_seatAvail <
                            double.parse(variable.selectedJumlahPenumpang) ||
                        jamLewat)
                    ? Container(
                        alignment: Alignment.center,
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                            color: CustomColor.grey,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "Pesan",
                          style: TextStyle(
                              color: CustomColor.white,
                              fontSize: Dimensions.smallTextSize),
                        ),
                      )
                    : GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                              color: CustomColor.red,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "Pesan",
                            style: TextStyle(
                                color: CustomColor.white,
                                fontSize: Dimensions.smallTextSize),
                          ),
                        ),
                        onTap: () {
                          // _saveBus(context);
                          // (variable.token == null)
                          //     ? Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) => SignInScreen()))
                          //     : (variable.checkPulangPergi == true)
                          //         ? Navigator.of(context).push(
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     SearchResultPulangScreen()))
                          //         : Navigator.of(context).push(
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     PassenggerFormScreen()));
                        },
                      )
              ],
            )
          ],
        )
      ],
    );
  }

  _saveBus(BuildContext context) {
    setState(() {
      variable.pergi_trip_id_no = widget.bus.pergi_trip_id_no;
      variable.pergi_trip_route_id = widget.bus.pergi_trip_route_id;
      variable.pergi_shedule_id = widget.bus.pergi_shedule_id;
      variable.pergi_pickup_trip_location =
          widget.bus.pergi_pickup_trip_location;
      variable.pergi_drop_trip_location = widget.bus.pergi_drop_trip_location;
      variable.pergi_type = widget.bus.pergi_type;
      variable.pergi_type_class = widget.bus.pergi_type_class;
      variable.pergi_fleet_seats = widget.bus.pergi_fleet_seats;
      variable.pergi_fleet_registration_id =
          widget.bus.pergi_fleet_registration_id;
      variable.pergi_price = widget.bus.pergi_price;
      variable.pergi_duration = widget.bus.pergi_duration;
      variable.pergi_start = widget.bus.pergi_start;
      variable.pergi_end = widget.bus.pergi_end;
      variable.pergi_seatPicked = widget.bus.pergi_seatPicked;
      variable.pergi_seatAvail = widget.bus.pergi_seatAvail.toString();
      variable.pergi_resto_id = widget.bus.pergi_resto_id;
    });
  }
}

class BusDetailModalPergiWidget extends StatefulWidget {
  final BusPergi bus;
  final String trip_id_no;
  final String trip_route_id;
  final String shedule_id;
  final String trip_route_name;
  final String pickup_trip_location;
  final String drop_trip_location;
  final String type;
  final String type_class;
  final String image;
  final String fleet_seats;
  final String fleet_registration_id;
  final String price;
  final String duration;
  final String start;
  final String end;
  final String seatPicked;
  final int seatAvail;

  BusDetailModalPergiWidget({
    this.bus,
    this.trip_id_no,
    this.trip_route_id,
    this.shedule_id,
    this.trip_route_name,
    this.pickup_trip_location,
    this.drop_trip_location,
    this.type,
    this.type_class,
    this.image,
    this.fleet_seats,
    this.fleet_registration_id,
    this.price,
    this.duration,
    this.start,
    this.end,
    this.seatPicked,
    this.seatAvail,
  });

  @override
  _BusDetailModalPergiWidgetState createState() =>
      _BusDetailModalPergiWidgetState();
}

class _BusDetailModalPergiWidgetState extends State<BusDetailModalPergiWidget> {
  BusPergi bus;
  List list = [];
  int index = 0;
  List<SlotPergi> _slotList = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSlot();
  }

  getSlot() async {
    await SlotPergiList.list(widget.trip_id_no, widget.trip_route_id,
            widget.fleet_registration_id, widget.type)
        .then((value) {
      setState(() {
        _slotList = value;
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [_detailModalBody(context)],
                  ),
                )
              : Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                )
        ],
      ),
    );
  }

  _detailModalBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: <Widget>[
          _busInfoWidget(context),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailsWidget(context),
              _availableSeatWidget(context),
            ],
          ),
          SizedBox(height: 20),
          _buttonWidget(context),
        ],
      ),
    );
  }

  _busInfoWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: widget.image,
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 200,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  _detailsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.type_class,
            style: TextStyle(
                fontSize: Dimensions.defaultTextSize,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Text("Harga",
                style: TextStyle(fontSize: Dimensions.defaultTextSize))
          ],
        ),
        Row(
          children: [
            Text(
              rupiah(widget.price),
              style: TextStyle(
                  color: CustomColor.red,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.defaultTextSize),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text("Sisa Kursi",
                style: TextStyle(fontSize: Dimensions.defaultTextSize))
          ],
        ),
        Row(
          children: [
            Text(
              widget.seatAvail.toString() + " Kursi",
              style: TextStyle(
                  color: CustomColor.darkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.defaultTextSize),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(widget.start,
                style: TextStyle(fontSize: Dimensions.defaultTextSize))
          ],
        ),
        Row(
          children: [
            Text(
              widget.pickup_trip_location,
              style: TextStyle(
                  color: CustomColor.darkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.defaultTextSize),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(widget.end,
                style: TextStyle(fontSize: Dimensions.defaultTextSize))
          ],
        ),
        Row(
          children: [
            Text(
              widget.drop_trip_location,
              style: TextStyle(
                  color: CustomColor.darkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.defaultTextSize),
            ),
          ],
        )
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: Dimensions.buttonHeight,
        decoration: BoxDecoration(
            color: CustomColor.red,
            borderRadius: BorderRadius.circular(Dimensions.radius)),
        child: Center(
          child: Text(
            "Tutup",
            style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.defaultTextSize,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  _availableSeatWidget(BuildContext context) {
    return Container(
      child: _allTicketWidget(context),
    );
  }

  _allTicketWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        mainAxisSpacing: 10,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          _slotList.length,
          (index) {
            SlotPergi slot = _slotList[index];
            return slot.pergi_isSeat
                ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: slot.pergi_isAvailable
                              ? CustomColor.white
                              : Colors.grey,
                          border: Border.all(color: CustomColor.grey),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(
                        child: Text(
                          slot.pergi_name,
                          style: TextStyle(
                              color: slot.pergi_isAvailable
                                  ? CustomColor.darkGrey
                                  : CustomColor.white,
                              fontSize: Dimensions.extraSmallTextSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class FilterPergiScreen extends StatefulWidget {
  @override
  _FilterPergiScreenState createState() => _FilterPergiScreenState();
}

class _FilterPergiScreenState extends State<FilterPergiScreen> {
  String _valSortBy;
  List sortBy = [
    "Harga Terendah",
    "Harga Tertinggi",
    "Keberangkatan Awal",
    "Keberangkatan Akhir",
    "Kedatangan Awal",
    "Kedatangan Akhir",
  ];

  String _valUnitType;
  List unitType = [];

  String _valFromCity;
  String _valToCity;
  List city = [];

  DateTime selectedDatePergi = DateTime.now();

  String _valJumlahPenumpang;
  List<String> jumlahPenumpang = ["1", "2", "3", "4"];

  String _valClassList;
  List classList = [];

  @override
  void initState() {
    super.initState();
    getUnitType();
    getCity();
    getClassList();
    if (variable.selectedKelasArmada != "") {
      setState(() {
        _valClassList = variable.selectedKelasArmada;
      });
    }
  }

  getUnitType() async {
    var response = await Dio().post(dotenv.env['BASE_URL'] + "/dataunit");
    var data = UnitTypeModel.fromJsonList(response.data);
    setState(() {
      unitType = data;
    });
  }

  getCity() async {
    var response = await Dio().post(dotenv.env['BASE_URL'] + "/datakota");
    var data = CityModel.fromJsonList(response.data);
    setState(() {
      city = data;
    });
  }

  getClassList() async {
    var response = await Dio().post(dotenv.env['BASE_URL'] + "/datakelas");
    var data = ClassModel.fromJsonList(response.data);
    data.add(ClassModel(id: "0", kelas: "Semua Kelas"));
    data.sort((a, b) => a.id.compareTo(b.id));
    setState(() {
      classList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  bodyWidget(context),
                  buttonWidget(context),
                ],
              ),
            )
          ]),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 30,
        left: 30,
        right: 30,
      ),
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
            "Filter",
            style: TextStyle(fontSize: Dimensions.defaultTextSize),
          )),
          // SizedBox(height: 10),
          // _unitType(context),
          // SizedBox(height: 10),
          // _datePergi(context),
          // SizedBox(height: 10),
          // _jumlahPenumpang(context),
          SizedBox(height: 10),
          // _cityFrom(context),
          // SizedBox(height: 10),
          // _cityTo(context),
          // SizedBox(height: 10),
          _classList(context),
          SizedBox(height: 10),
          _sortBy(context),
        ],
      ),
    );
  }

  _unitType(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Tipe Unit"),
                value: _valUnitType,
                items: unitType.map((value) {
                  return DropdownMenuItem(
                    child: Text(value.toString()),
                    value: value.toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valUnitType = value.toString();
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _cityFrom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Kota Keberangkatan"),
                value: _valFromCity,
                items: city.map((value) {
                  return DropdownMenuItem(
                    child: Text(value.toString()),
                    value: value.toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valFromCity = value.toString();
                    variable.selectedFromCity = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _cityTo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Kota Tujuan"),
                value: _valToCity,
                items: city.map((value) {
                  return DropdownMenuItem(
                    child: Text(value.toString()),
                    value: value.toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valToCity = value.toString();
                    variable.selectedToCity = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _sortBy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Urut Berdasarkan"),
                value: variable.pergi_sort_by,
                items: sortBy.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    // _valSortBy = value;
                    variable.pergi_sort_by = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _datePergi(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.black.withOpacity(0.1), width: 1))),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(),
                child: Text(
                  variable.datePergi,
                  style: TextStyle(
                      color: CustomColor.greyColor,
                      fontSize: Dimensions.defaultTextSize),
                ),
              ),
            ),
          ),
          onTap: () {
            __datePergi(context);
          },
        ),
      ],
    );
  }

  __datePergi(BuildContext context) async {
    final DateTime pickedPergi = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: selectedDatePergi,
        maxTime: selectedDatePergi.add(Duration(days: 90)),
        currentTime: selectedDatePergi,
        locale: LocaleType.id);
    setState(() {
      selectedDatePergi = pickedPergi;
      variable.datePergi = "${selectedDatePergi.toLocal()}".split(' ')[0];
    });
  }

  _jumlahPenumpang(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Jumlah Penumpang"),
                value: _valJumlahPenumpang,
                items: jumlahPenumpang.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valJumlahPenumpang = value;
                    variable.selectedJumlahPenumpang = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _classList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton(
                isExpanded: true,
                hint: Text("Kelas"),
                value: _valClassList,
                items: classList.map((value) {
                  var id = value.id;
                  var kelas = value.kelas;
                  return DropdownMenuItem(
                    child: Text(kelas.toString()),
                    value: id.toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valClassList = value.toString();
                    variable.selectedKelasArmada = value.toString();
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  buttonWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 30, left: 30, right: 30, top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: Dimensions.buttonHeight,
                decoration: BoxDecoration(
                    color: CustomColor.red,
                    borderRadius: BorderRadius.circular(Dimensions.radius)),
                child: Center(
                  child: Text(
                    "Reset",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.largeTextSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {
                variable.selectedKelasArmada = "";
                variable.pergi_sort_by = "Harga Terendah";
                Navigator.pop(context);
              },
            ),
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: Dimensions.buttonHeight,
                decoration: BoxDecoration(
                    color: CustomColor.red,
                    borderRadius: BorderRadius.circular(Dimensions.radius)),
                child: Center(
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.largeTextSize,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}
