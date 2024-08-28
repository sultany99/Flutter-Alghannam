import 'package:alghannam_transport/data/providers.dart';
import 'package:alghannam_transport/utils/colors.dart';
import 'package:firebase_for_all/firebase/firestore/bridge.dart';
import 'package:firedart/generated/google/firestore/v1/document.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/dimantions.dart';

class DailyGainView extends StatefulWidget {
  ColRef<Map<String, Object?>> dailyGainColReference;
  bool backHome;
  DailyGainView(
      {super.key, required this.dailyGainColReference, required this.backHome});

  @override
  State<DailyGainView> createState() => _DailyGainViewState();
}

class _DailyGainViewState extends State<DailyGainView> {
  String pickedDate = 'اختر التاريخ';
  double gainValue = 0;
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat('EEE , d/M/y');
    return Expanded(
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/photos/25%.png",
            ),
          ),
          Consumer2<ViewProvider, DataProvider>(
              builder: (context, viewProvider, dataProvider, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: d.height100 * 0.1,
                  ),
                  IconButton(
                      onPressed: () {
                        (widget.backHome)
                            ? viewProvider.toDefaultLeft()
                            : viewProvider.toBusPage();
                      },
                      icon: Icon(Icons.arrow_forward_ios)),
                  SizedBox(
                    height: d.height100 * 0.65,
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
                        viewProvider.customProgressDialog(context: context);
                        gainValue = await dataProvider.getDailyGain(
                            context: context,
                            dailyGainDate: date,
                            dailyGainColReference:
                                widget.dailyGainColReference);
                        Navigator.of(context).pop();

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
