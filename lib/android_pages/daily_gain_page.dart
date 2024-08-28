import 'dart:io';

import 'package:alghannam_transport/data/providers.dart';
import 'package:alghannam_transport/utils/colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_for_all/firebase/firestore/bridge.dart';
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/dimantions.dart';

class DailyGainPage extends StatefulWidget {
  ColRef<Map<String, Object?>> dailyGainColReference;
  DailyGainPage({
    super.key,
    required this.dailyGainColReference,
  });

  @override
  State<DailyGainPage> createState() => _DailyGainPageState();
}

class _DailyGainPageState extends State<DailyGainPage> {
  String pickedDate = 'اختر التاريخ';
  double gainValue = 0;
  DateTime date = DateTime.now();
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
          Consumer<DataProvider>(builder: (context, dataProvider, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: d.height100,
                  ),
                  Text(
                    "الربح اليومي",
                    style: TextStyle(
                        fontSize: d.fontSize21 * 2, color: colors.mainYallo),
                  ),
                  SizedBox(
                    height: d.height100 * 1.5,
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
                                  date = value;
                                  pickedDate = format.format(value);
                                  setState(() {});
                                }
                              });
                            },
                            child: Text(
                              pickedDate,
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
                            "التاريخ",
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
                          final con = await Connectivity().checkConnectivity();
                          final result = await InternetAddress.lookup(
                              'console.firebase.google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty &&
                              // ignore: use_build_context_synchronously
                              !(con == ConnectivityResult.none)) {
                            ViewProvider()
                                .androidCustomProgressDialog(context: context);
                            gainValue = await dataProvider.getDailyGain(
                                context: context,
                                dailyGainDate: DateUtils.dateOnly(date),
                                dailyGainColReference:
                                    widget.dailyGainColReference);
                            Navigator.of(context).pop();
                          } else {
                            print('not connected');
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ViewProvider().errorDialog(
                                    "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                    context);
                              },
                            );
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
          })
        ],
      ),
    );
  }
}
