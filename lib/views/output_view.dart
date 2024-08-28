import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

import '../data/providers.dart';
import '../utils/dimantions.dart';
import '../utils/colors.dart';

class OutputView extends StatefulWidget {
  const OutputView({super.key});

  @override
  State<OutputView> createState() => _OutputViewState();
}

String _selected = "نوع غير معروف";

class _OutputViewState extends State<OutputView> {
  int selected = -1;
  String pickedDate = "اختر التاريخ";
  Widget custumeRadio(
      String text, String _index, Function(void Function()) sState) {
    return OutlinedButton(
      onPressed: () {
        sState(() {
          _selected = _index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: (_selected == _index) ? colors.mainYallo : colors.mainGray,
        ),
      ),
    );
  }

  DateTime date = DateTime.now();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat('EEE , d/M/y');
    TextEditingController notes = TextEditingController();

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
              ColRef<Map<String, Object?>> outputsCol =
                  dataProvider.getOutputsCollectionReference;

              return Row(
                children: [
                  dataProvider.outputId != ''
                      ? Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: d.width20 * 1.5),
                            height: d.height200 * 2,
                            alignment: Alignment.center,
                            child: FutureBuilder(
                                future: dataProvider.getOutputDocumentReference
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: LottieBuilder.asset(
                                          height: 60,
                                          "assets/lottie/alghannamProgressInd.json"),
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!["Name"].toString(),
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                            Text(
                                              "اسم المدفوع",
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!["Type"].toString(),
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                            Text(
                                              "نوع المدفوع",
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!["Value"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                            Text(
                                              "القيمة المدفوعة",
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              format.format(
                                                  snapshot.data!['Date']),
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                            Text(
                                              "تاريخ الدفع",
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await dataProvider
                                                .getOutputDocumentReference
                                                .get()
                                                .then(
                                              (value) {
                                                notes.text = value
                                                    .data()!["notes"]
                                                    .toString();
                                              },
                                            );
                                            // ignore: use_build_context_synchronously
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom:
                                                              d.height20 / 2),
                                                      width: d.width100 * 0.9,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                d.height200 *
                                                                    3.2,
                                                            child: TextField(
                                                              textAlign:
                                                                  TextAlign.end,
                                                              controller: notes,
                                                              expands: true,
                                                              minLines: null,
                                                              maxLines: null,
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              dataProvider
                                                                  .getOutputDocumentReference
                                                                  .update({
                                                                "notes":
                                                                    notes.text
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                "حفظ"),
                                                          ),
                                                        ],
                                                      )),
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            "ملاحظات",
                                            style: TextStyle(
                                                fontSize: d.fontSize18),
                                          ),
                                        ),
                                        Card(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: colors.mainYallo2,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: colors.mainYallo,
                                                    width: 1,
                                                  )),
                                              child: IconButton(
                                                  onPressed: () async {
                                                    try {
                                                      final con =
                                                          await Connectivity()
                                                              .checkConnectivity();
                                                      final result =
                                                          await InternetAddress
                                                              .lookup(
                                                                  'console.firebase.google.com');
                                                      if (result.isNotEmpty &&
                                                          result[0]
                                                              .rawAddress
                                                              .isNotEmpty &&
                                                          !(con ==
                                                              ConnectivityResult
                                                                  .none)) {
                                                        selected = -1;
                                                        viewProvider
                                                            .customProgressDialog(
                                                                context:
                                                                    context);
                                                        try {
                                                          await dataProvider
                                                              .deleteOutput(
                                                                  context:
                                                                      context);
                                                        } on FirebaseException catch (e) {
                                                          await viewProvider
                                                              .errorDialog(
                                                                  e.code,
                                                                  context);
                                                        }

                                                        // ignore: use_build_context_synchronously

                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        print('not connected');
                                                        // ignore: use_build_context_synchronously
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return ViewProvider()
                                                                .errorDialog(
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
                                                          return ViewProvider()
                                                              .errorDialog(
                                                                  "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                                                  context);
                                                        },
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: colors.mainYallo,
                                                  )),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                }),
                          ),
                        )
                      : Expanded(child: Container()),
                  SizedBox(
                    width: d.width100 * 0.8,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.refresh_rounded)),
                                IconButton(
                                    onPressed: () {
                                      viewProvider.toBusPage();
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)),
                              ],
                            ),
                            Expanded(
                              child: FutureBuilder(
                                  future: outputsCol.orderBy("Date").get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: LottieBuilder.asset(
                                            height: 60,
                                            "assets/lottie/alghannamProgressInd.json"),
                                      );
                                    } else {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.size,
                                        itemBuilder: ((context, index) {
                                          return InkWell(
                                            onTap: () {
                                              dataProvider.setOutputId(snapshot
                                                  .data?.docs
                                                  .elementAt(index)
                                                  .id);
                                              setState(() {
                                                selected = index;
                                              });
                                            },
                                            child: Card(
                                              color: (selected == index)
                                                  ? colors.mainYallo2
                                                  : Colors.grey[100],
                                              borderOnForeground:
                                                  !(selected == index),
                                              elevation:
                                                  selected == index ? 20 : 2,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: d.height20 / 7,
                                                    bottom: d.height20 / 7,
                                                    right: d.width20 / 4,
                                                    left: d.width20 / 4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: colors.mainYallo,
                                                  ),
                                                ),
                                                height: d.height20 * 4.25,
                                                /* margin: EdgeInsets.only(
                                                  left: d.height20,
                                                  right: d.height20,
                                                ),*/
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      width: 90,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(3),
                                                        ),
                                                        border: Border.all(
                                                          strokeAlign: BorderSide
                                                              .strokeAlignOutside,
                                                          color:
                                                              colors.mainYallo,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        snapshot.data!.docs
                                                            .elementAt(
                                                                index)['Value']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                d.fontSize18 *
                                                                    0.80,
                                                            color: colors
                                                                .mainBlack),
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.docs
                                                          .elementAt(
                                                              index)['Name'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: d.fontSize18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: d.height20),
                          child: FloatingActionButton(
                            backgroundColor: colors.mainYallo,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController outputName =
                                        TextEditingController();
                                    TextEditingController outputVal =
                                        TextEditingController();
                                    return Dialog(
                                      child: StatefulBuilder(
                                          builder: (_context, setState1) {
                                        return Container(
                                          padding:
                                              EdgeInsets.all(d.width50 / 10),
                                          width: d.width100 * 0.8,
                                          height: double.infinity,
                                          child: Form(
                                            key: formKey,
                                            child: //no radio button will be selected on initial
                                                Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.of(_context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(Icons
                                                        .arrow_forward_ios)),
                                                const Text("اختر نوع الوارد"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        custumeRadio(
                                                            "سلف السائق",
                                                            "سلف السائق",
                                                            setState1),
                                                        SizedBox(
                                                          height:
                                                              d.height20 / 2,
                                                        ),
                                                        custumeRadio("صيانة",
                                                            "صيانة", setState1),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        custumeRadio(
                                                            "مخالفات",
                                                            "مخالفات",
                                                            setState1),
                                                        SizedBox(
                                                          height:
                                                              d.height20 / 2,
                                                        ),
                                                        custumeRadio("مازوت",
                                                            "مازوت", setState1),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                TextFormField(
                                                  controller: outputName,
                                                  textAlign: TextAlign.end,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 1, //
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                    hintText: "اسم المدفوع",
                                                    hintStyle: TextStyle(
                                                        fontSize: d.fontSize18),
                                                  ),
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'ادخل نص';
                                                    }
                                                    if (!RegExp(r'^[0-9]+$')
                                                        .hasMatch(value)) {
                                                      return 'ادخل ارقام فقط';
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: outputVal,
                                                  textAlign: TextAlign.end,
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 1, //
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                    hintText: "قيمة المدفوع",
                                                    hintStyle: TextStyle(
                                                        fontSize: d.fontSize18),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        showDatePicker(
                                                                context:
                                                                    _context,
                                                                initialDate:
                                                                    date,
                                                                firstDate:
                                                                    DateTime(
                                                                        2022),
                                                                lastDate:
                                                                    DateTime(
                                                                        2050))
                                                            .then((value) {
                                                          if (value != null) {
                                                            date = value;
                                                            pickedDate = format
                                                                .format(value);
                                                            setState1(() {});
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        pickedDate,
                                                        style: TextStyle(
                                                          fontSize:
                                                              d.fontSize21,
                                                        ),
                                                      ),
                                                    ),
                                                    Text("التاريخ")
                                                  ],
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      try {
                                                        final con =
                                                            await Connectivity()
                                                                .checkConnectivity();
                                                        final result =
                                                            await InternetAddress
                                                                .lookup(
                                                                    'console.firebase.google.com');
                                                        if (result.isNotEmpty &&
                                                            result[0]
                                                                .rawAddress
                                                                .isNotEmpty &&
                                                            !(con ==
                                                                ConnectivityResult
                                                                    .none)) {
                                                          viewProvider
                                                              .customProgressDialog(
                                                                  context:
                                                                      context);
                                                          try {
                                                            await dataProvider.addNewOutput(
                                                                context:
                                                                    context,
                                                                outputName:
                                                                    outputName
                                                                        .text,
                                                                outputType:
                                                                    _selected,
                                                                outputDate:
                                                                    date,
                                                                outputVal: double
                                                                    .parse(outputVal
                                                                        .text));
                                                          } on FirebaseException catch (e) {
                                                            await viewProvider
                                                                .errorDialog(
                                                                    e.code,
                                                                    context);
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          print(
                                                              'not connected');
                                                          // ignore: use_build_context_synchronously
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return ViewProvider()
                                                                  .errorDialog(
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
                                                            return ViewProvider()
                                                                .errorDialog(
                                                                    "لا يوجد اتصال بالخادم\nاعد المحاولة لاحقا",
                                                                    context);
                                                          },
                                                        );
                                                      }
                                                    }
                                                    // ignore: use_build_context_synchronously

                                                    _selected = "نوع غير معروف";
                                                    setState(() {});
                                                  },
                                                  child: const Text("حفظ"),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  });
                              selected = -1;
                              _selected = "نوع غير معروف";
                              setState(() {});
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
