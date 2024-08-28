import 'dart:io';

import 'package:alghannam_transport/utils/colors.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/providers.dart';
import '../utils/dimantions.dart';

class FromToGainPage extends StatefulWidget {
  ColRef<Map<String, Object?>> dailyGainColReference;
  FromToGainPage({
    super.key,
    required this.dailyGainColReference,
  });

  @override
  State<FromToGainPage> createState() => _FromToGainPageState();
}

class _FromToGainPageState extends State<FromToGainPage> {
  String firstPickedDate = 'اختر التاريخ';
  String secondPickedDate = 'اختر التاريخ';
  DateTime _firstPickedDate = DateTime.now();
  DateTime _secondPickedDate = DateTime.now();
  List<DailyGain> gainList = [];
  double gainValue = 0;
  Map data = {};
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat('EEE , d/M/y');
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(width: d.height100 * 0.55),
        ],
        iconTheme: IconThemeData(size: d.height25 * 1.25, color: Colors.white),
        toolbarHeight: d.height100 * 0.55,
        title: Center(
          child: Text(
            "الغنام للنقل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: d.fontSize21),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              width: d.width100 * 3,
              "assets/photos/25%.png",
            ),
          ),
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: d.height50,
                    ),
                    Text(
                      "الربح من-الى",
                      style: TextStyle(
                          fontSize: d.fontSize21 * 2, color: colors.mainYallo),
                    ),
                    SizedBox(
                      height: d.height100 * 0.75,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2022),
                                        lastDate: DateTime(2050))
                                    .then((value) {
                                  if (value != null) {
                                    _firstPickedDate = value;
                                    firstPickedDate = format.format(
                                      value,
                                    );
                                    setState(() {});
                                  }
                                });
                              },
                              child: Text(
                                firstPickedDate,
                                style: TextStyle(
                                  fontSize: d.fontSize21,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: d.height50,
                            ),
                            TextButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2022),
                                        lastDate: DateTime(2050))
                                    .then((value) {
                                  if (value != null) {
                                    _secondPickedDate = value;
                                    secondPickedDate = format.format(
                                      value,
                                    );
                                    setState(() {});
                                  }
                                });
                              },
                              child: Text(
                                secondPickedDate,
                                style: TextStyle(
                                  fontSize: d.fontSize21,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: d.height50,
                            ),
                            Text(
                              gainValue.toString(),
                              style: TextStyle(fontSize: d.fontSize21),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "التاريخ الاول",
                              style: TextStyle(
                                fontSize: d.fontSize21,
                              ),
                            ),
                            SizedBox(
                              height: d.height50,
                            ),
                            Text(
                              "التاريخ الثاني",
                              style: TextStyle(
                                fontSize: d.fontSize21,
                              ),
                            ),
                            SizedBox(
                              height: d.height50,
                            ),
                            Text(
                              "القيمة",
                              style: TextStyle(
                                fontSize: d.fontSize21,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: d.height100,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            final result = await InternetAddress.lookup(
                                'console.firebase.google.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              print('connected');
                              ViewProvider().androidCustomProgressDialog(
                                  context: context);
                              data = await dataProvider.getFromToGain(
                                context: context,
                                startDate: _firstPickedDate,
                                endDate: _secondPickedDate,
                                dailyGainColReference:
                                    widget.dailyGainColReference,
                              );
                              gainList = data["gainList"];
                              gainValue = data["gain"];
                              Navigator.of(context).pop();
                            }
                          } on SocketException catch (_) {
                            print('not connected');
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ViewProvider().errorDialog(
                                    "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                    context);
                              },
                            );
                          }

                          setState(() {});
                        },
                        child: Text(
                          "حساب",
                          style: TextStyle(fontSize: d.fontSize21),
                        ))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
