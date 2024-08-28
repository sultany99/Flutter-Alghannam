import 'package:alghannam_transport/utils/colors.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/providers.dart';
import '../utils/dimantions.dart';

class FromToGainView extends StatefulWidget {
  ColRef<Map<String, Object?>> dailyGainColReference;
  bool backHome;
  FromToGainView(
      {super.key, required this.dailyGainColReference, required this.backHome});

  @override
  State<FromToGainView> createState() => _FromToGainViewState();
}

class _FromToGainViewState extends State<FromToGainView> {
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
                      height: d.height100 * 0.50,
                    ),
                    Text(
                      "الربح من-الى",
                      style: TextStyle(
                          fontSize: d.fontSize21 * 2, color: colors.mainYallo),
                    ),
                    SizedBox(
                      height: d.height100 * 1.25,
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
                      height: d.height100 / 4,
                    ),
                    TextButton(
                        onPressed: () {
                          var s = MediaQuery.of(context).size;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: s.height,
                                          width: s.width,
                                          child: SfCartesianChart(
                                            series: <ChartSeries>[
                                              StackedLineSeries<DailyGain,
                                                  String>(
                                                color: colors.mainYallo3,
                                                dataSource: gainList,
                                                xValueMapper:
                                                    (DailyGain dG, _) =>
                                                        DateFormat("d/M/y")
                                                            .format(dG.date),
                                                yValueMapper:
                                                    (DailyGain dG, _) =>
                                                        dG.value,
                                              )
                                            ],
                                            primaryXAxis:
                                                CategoryAxis(minimum: 2),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const Icon(Icons
                                                .arrow_forward_ios_rounded)),
                                      ]),
                                );
                              });
                        },
                        child: Text("عرض مخطط الارباح")),
                    SizedBox(
                      height: d.height100 / 2,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          viewProvider.customProgressDialog(context: context);
                          data = await dataProvider.getFromToGain(
                            context: context,
                            startDate: _firstPickedDate,
                            endDate: _secondPickedDate,
                            dailyGainColReference: widget.dailyGainColReference,
                          );
                          gainList = data["gainList"];
                          gainValue = data["gain"];
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
