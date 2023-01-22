// ignore_for_file: unused_import, unused_element, unnecessary_import, non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_constructors, curly_braces_in_flow_control_structures, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_types_as_parameter_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:core';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:j99_mobile_flutter_self_service/data/imageModel.dart.dart';
import 'package:j99_mobile_flutter_self_service/data/cityModel.dart';
import 'package:j99_mobile_flutter_self_service/data/classModel.dart';
import 'package:j99_mobile_flutter_self_service/utility/color.dart';
import 'package:j99_mobile_flutter_self_service/utility/dimension.dart';
import 'package:j99_mobile_flutter_self_service/utility/style.dart';
import 'package:j99_mobile_flutter_self_service/utility/variable.dart'
    as variable;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool imageLoad = true;
  bool prefixLoad = true;
  String imagePrefix;
  List imageList;

  List<String> jumlahPenumpang = ["1", "2", "3", "4"];

  DateTime dateNow = DateTime.now();
  DateTime selectedDatePergi = DateTime.now();
  DateTime selectedDatePulang = DateTime.now();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getImagePrefix();
    getImage();
  }

  getImagePrefix() async {
    await ImagePrefix.list().then((value) {
      setState(() {
        imagePrefix = value;
        prefixLoad = false;
      });
    });
  }

  getImage() async {
    await ImageList.list().then((value) {
      setState(() {
        imageList = value;
        imageLoad = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeightMinusAppBarMinusStatusBar =
        MediaQuery.of(context).size.height - 150;
    return Scaffold(
        backgroundColor: CustomColor.white,
        key: scaffoldKey,
        body: Container(
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: screenHeightMinusAppBarMinusStatusBar),
            child: bodyWidget(context),
          )),
        ));
  }

  bodyWidget(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      carouselWidget(context),
      Container(
        alignment: Alignment.bottomCenter,
        transform: Matrix4.translationValues(0.0, -30.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: CustomColor.white,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, right: 40, left: 40),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: DropdownSearch<CityModel>(
                      mode: Mode.DIALOG,
                      showClearButton: false,
                      maxHeight: 250,
                      label: "Kota Asal",
                      showSearchBox: true,
                      selectedItem: variable.selectedFromCity,
                      searchBoxDecoration: InputDecoration(
                        labelText: "Kota Asal",
                        suffixIcon: Icon(Icons.search),
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        labelStyle: CustomStyle.textStyle,
                        focusedBorder: CustomStyle.focusBorder,
                        enabledBorder: CustomStyle.focusErrorBorder,
                        focusedErrorBorder: CustomStyle.focusErrorBorder,
                        errorBorder: CustomStyle.focusErrorBorder,
                        hintStyle: CustomStyle.textStyle,
                      ),
                      onFind: (String) async {
                        var response = await Dio().post(
                          dotenv.env['BASE_URL'] + "/datakota",
                        );
                        var dataFromCity =
                            CityModel.fromJsonList(response.data);
                        if (variable.selectedToCity == null)
                          return dataFromCity;
                        dataFromCity.removeWhere((item) =>
                            item.namaKota ==
                            variable.selectedToCity.toString());
                        return dataFromCity;
                      },
                      onChanged: (data) {
                        setState(() {
                          variable.selectedFromCity = data;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: DropdownSearch<CityModel>(
                        mode: Mode.DIALOG,
                        showClearButton: false,
                        maxHeight: 250,
                        label: "Kota Tujuan",
                        showSearchBox: true,
                        selectedItem: variable.selectedToCity,
                        searchBoxDecoration: InputDecoration(
                          labelText: "Kota Tujuan",
                          suffixIcon: Icon(Icons.search),
                        ),
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          labelStyle: CustomStyle.textStyle,
                          focusedBorder: CustomStyle.focusBorder,
                          enabledBorder: CustomStyle.focusErrorBorder,
                          focusedErrorBorder: CustomStyle.focusErrorBorder,
                          errorBorder: CustomStyle.focusErrorBorder,
                          hintStyle: CustomStyle.textStyle,
                        ),
                        onFind: (String) async {
                          var response = await Dio().post(
                            dotenv.env['BASE_URL'] + "/datakota",
                          );
                          var dataToCity =
                              CityModel.fromJsonList(response.data);
                          if (variable.selectedFromCity == null)
                            return dataToCity;
                          dataToCity.removeWhere((item) =>
                              item.namaKota ==
                              variable.selectedFromCity.toString());
                          return dataToCity;
                        },
                        onChanged: (data) {
                          setState(() {
                            variable.selectedToCity = data;
                          });
                        }),
                  ),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Pulang-Pergi?",
                              style: TextStyle(
                                  fontSize: Dimensions.defaultTextSize),
                            ),
                            Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                activeColor: CustomColor.red,
                                value: variable.checkPulangPergi,
                                onChanged: (bool value) {
                                  setState(() {
                                    variable.checkPulangPergi = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          child: Transform.rotate(
                            angle: 90 * math.pi / 180,
                            child: IconButton(
                              icon: Icon(Icons.swap_horiz_sharp),
                              color: CustomColor.red,
                              onPressed: () {
                                setState(() {
                                  var tempFrom;
                                  var tempTo;
                                  tempFrom = variable.selectedFromCity;
                                  tempTo = variable.selectedToCity;
                                  variable.selectedFromCity = tempTo;
                                  variable.selectedToCity = tempFrom;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        selectDatePergi(context),
                        variable.checkPulangPergi
                            ? SizedBox(width: 10)
                            : Container(),
                        variable.checkPulangPergi
                            ? selectDatePulang(context)
                            : Container(),
                      ],
                    )
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: DropdownSearch(
                      mode: Mode.BOTTOM_SHEET,
                      showClearButton: false,
                      maxHeight: 225,
                      items: jumlahPenumpang,
                      label: "Jumlah Penumpang",
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        labelStyle: CustomStyle.textStyle,
                        focusedBorder: CustomStyle.focusBorder,
                        enabledBorder: CustomStyle.focusErrorBorder,
                        focusedErrorBorder: CustomStyle.focusErrorBorder,
                        errorBorder: CustomStyle.focusErrorBorder,
                        hintStyle: CustomStyle.textStyle,
                      ),
                      onChanged: (jumlahPenumpang) {
                        setState(() {
                          variable.selectedJumlahPenumpang = jumlahPenumpang;
                        });
                      },
                      showSearchBox: false,
                      selectedItem: variable.selectedJumlahPenumpang,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: DropdownSearch<ClassModel>(
                      mode: Mode.BOTTOM_SHEET,
                      maxHeight: 225,
                      label: "Kelas Armada",
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        labelStyle: CustomStyle.textStyle,
                        focusedBorder: CustomStyle.focusBorder,
                        enabledBorder: CustomStyle.focusErrorBorder,
                        focusedErrorBorder: CustomStyle.focusErrorBorder,
                        errorBorder: CustomStyle.focusErrorBorder,
                        hintStyle: CustomStyle.textStyle,
                      ),
                      onFind: (String) async {
                        var response = await Dio().post(
                          dotenv.env['BASE_URL'] + "/datakelas",
                        );
                        var kelasArmada =
                            ClassModel.fromJsonList(response.data);
                        kelasArmada
                            .add(ClassModel(id: "0", kelas: "Semua Kelas"));
                        kelasArmada.sort((a, b) => a.id.compareTo(b.id));
                        return kelasArmada;
                      },
                      onChanged: (ClassModel data) {
                        if (data == null) {
                          setState(() {
                            variable.selectedKelasArmada = "";
                          });
                        } else {
                          setState(() {
                            variable.selectedKelasArmada = data.id;
                          });
                        }
                      },
                      showSearchBox: false,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 40, right: 40),
              child: GestureDetector(
                child: Container(
                  height: Dimensions.buttonHeight,
                  decoration: BoxDecoration(
                      color: CustomColor.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "CARI BUS",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.defaultTextSize),
                    ),
                  ),
                ),
                onTap: () {
                  if (variable.selectedFromCity == null) {
                    Fluttertoast.showToast(
                      msg: "Isi kota keberangkatan terlebih dahulu",
                      backgroundColor: CustomColor.red,
                      textColor: CustomColor.white,
                      gravity: ToastGravity.CENTER,
                    );
                  } else {
                    if (variable.selectedToCity == null) {
                      Fluttertoast.showToast(
                        msg: "Isi kota tujuan terlebih dahulu",
                        backgroundColor: CustomColor.red,
                        textColor: CustomColor.white,
                        gravity: ToastGravity.CENTER,
                      );
                    } else {
                      if (variable.selectedJumlahPenumpang == null) {
                        Fluttertoast.showToast(
                          msg: "Isi jumlah penumpang terlebih dahulu",
                          backgroundColor: CustomColor.red,
                          textColor: CustomColor.white,
                          gravity: ToastGravity.CENTER,
                        );
                      } else {
                        if (variable.datePergi == "Pergi") {
                          Fluttertoast.showToast(
                            msg: "Isi tanggal pergi terlebih dahulu",
                            backgroundColor: CustomColor.red,
                            textColor: CustomColor.white,
                            gravity: ToastGravity.CENTER,
                          );
                        } else {
                          if (variable.checkPulangPergi == true &&
                              variable.datePulang == "Pulang") {
                            Fluttertoast.showToast(
                              msg: "Isi tanggal pulang terlebih dahulu",
                              backgroundColor: CustomColor.red,
                              textColor: CustomColor.white,
                              gravity: ToastGravity.CENTER,
                            );
                          } else {
                            _navigateSearchResult(context);
                          }
                        }
                      }
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    ]);
  }

  carouselWidget(BuildContext context) {
    return Expanded(
      child: (imageLoad || prefixLoad)
          ? Center(child: CircularProgressIndicator())
          : Swiper(
              autoplay: true,
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                  imageUrl: imagePrefix + imageList[index].image,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                );
              },
              // itemCount: 1,
            ),
    );
  }

  selectDatePergi(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.marginSize * 0.5,
              ),
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
          _selectDatePergi(context);
        },
      ),
    );
  }

  selectDatePulang(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.marginSize * 0.5,
              ),
              child: Text(
                variable.datePulang,
                style: TextStyle(
                    color: CustomColor.greyColor,
                    fontSize: Dimensions.defaultTextSize),
              ),
            ),
          ),
        ),
        onTap: () {
          _selectDatePulang(context);
        },
      ),
    );
  }

  Future<void> _selectDatePergi(BuildContext context) async {
    final DateTime pickedPergi = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: dateNow,
        maxTime: dateNow.add(Duration(days: 90)),
        currentTime: dateNow,
        locale: LocaleType.id);
    setState(() {
      if (pickedPergi != null) {
        selectedDatePergi = pickedPergi;
        variable.datePergi = "${selectedDatePergi.toLocal()}".split(' ')[0];
        if (variable.datePulang != "Pulang") {
          DateTime tempDate = DateTime.parse(variable.datePulang);
          if (tempDate.isBefore(pickedPergi) || tempDate == pickedPergi) {
            DateTime newPulang = pickedPergi.add(Duration(days: 1));
            variable.datePulang = "${newPulang.toLocal()}".split(' ')[0];
          }
        }
      }
    });
  }

  Future<void> _selectDatePulang(BuildContext context) async {
    final DateTime pickedPulang = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: selectedDatePergi.add(Duration(days: 1)),
        maxTime: selectedDatePergi.add(Duration(days: 90)),
        currentTime: dateNow.add(Duration(days: 1)),
        locale: LocaleType.id);
    setState(() {
      if (pickedPulang != null) {
        selectedDatePulang = pickedPulang;
        variable.datePulang = "${selectedDatePulang.toLocal()}".split(' ')[0];
      }
    });
  }

  void _navigateSearchResult(BuildContext context) async {
    print("next screen");
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SearchResultPergiScreen()),
    // );
    // resetVariable();
  }
}
