import 'package:alghannam_transport/utils/colors.dart';
import 'package:firebase_for_all/firebase/firestore/bridge.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/providers.dart';
import '../utils/dimantions.dart';

class MonthlyGainView extends StatefulWidget {
  ColRef<Map<String, Object?>> dailyGainColReference;
  bool backHome;
  MonthlyGainView(
      {super.key, required this.dailyGainColReference, required this.backHome});

  @override
  State<MonthlyGainView> createState() => _MonthlyGainViewState();
}

class _MonthlyGainViewState extends State<MonthlyGainView> {
  String pickedDate = 'اختر التاريخ';
  double gainValue = 0;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat.yM('en');
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
                        widget.backHome
                            ? viewProvider.toDefaultLeft()
                            : viewProvider.toBusPage();
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                    SizedBox(
                      height: d.height100 * 0.65,
                    ),
                    Text(
                      "الربح الشهري",
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
                                showMonthYearPicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2022),
                                        lastDate: DateTime(2050))
                                    .then((value) {
                                  if (value != null) {
                                    date = value;
                                    pickedDate = format.format(
                                      value,
                                    );
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
                          gainValue = await dataProvider.getMonthlyGain(
                              context: context,
                              dailyGainColReference:
                                  widget.dailyGainColReference,
                              monthlyGainDate: date);
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
            },
          ),
        ],
      ),
    );
  }
}
