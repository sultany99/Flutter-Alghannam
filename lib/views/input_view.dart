import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_for_all/firebase/firestore/bridge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../data/providers.dart';
import '../utils/dimantions.dart';
import '../utils/colors.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  int selected = -1;
  String _selected = "نوع غير معروف";

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
              var inputViewsCol = dataProvider.getBusListCollectionReference
                  .doc(dataProvider.busId)
                  .collection('inputs');
              print(dataProvider.inputId);
              return Row(
                children: [
                  (dataProvider.inputId != '')
                      ? Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: d.width20 * 1.5),
                            height: d.height200 * 2,
                            alignment: Alignment.center,
                            child: FutureBuilder(
                                future: dataProvider.getIntputDocumentReference
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
                                              "اسم الوارد",
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
                                              "نوع الوارد",
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
                                              "القيمة الواردة",
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
                                              "تاريخ الوارد",
                                              style: TextStyle(
                                                  fontSize: d.fontSize18),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            notes.text = '';
                                            await dataProvider
                                                .getIntputDocumentReference
                                                .get()
                                                .then(
                                              (value) {
                                                if (value.exists &&
                                                    value
                                                            .data()?["notes"]
                                                            .toString() !=
                                                        null) {
                                                  notes.text = value
                                                      .data()!["notes"]
                                                      .toString();
                                                }
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
                                                                  .getIntputDocumentReference
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
                                            // ignore: use_build_context_synchronously
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
                                                              .deleteInput(
                                                                  context:
                                                                      context);
                                                          Navigator.of(context)
                                                              .pop();
                                                        } on FirebaseException catch (e) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await viewProvider
                                                              .errorDialog(
                                                                  e.code,
                                                                  context);
                                                        }

                                                        // ignore: use_build_context_synchronously

                                                        setState(() {});
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
                                      dataProvider.inputId = '';
                                      viewProvider.toBusPage();
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)),
                              ],
                            ),
                            Expanded(
                              child: FutureBuilder(
                                  future: inputViewsCol.get(),
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
                                            onTap: () async {
                                              selected = index;
                                              await dataProvider.setInputId(
                                                  snapshot.data!.docs
                                                      .elementAt(index)
                                                      .id);
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
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3,
                                                              right: 3),
                                                      height: 30,
                                                      width: 60,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(5),
                                                        ),
                                                        border: Border.all(
                                                          strokeAlign: BorderSide
                                                              .strokeAlignOutside,
                                                          color:
                                                              colors.mainYallo,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        snapshot.data!.docs
                                                            .elementAt(
                                                                index)['Value']
                                                            .toString(),
                                                        style: TextStyle(
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
                            child: Icon(Icons.add),
                            backgroundColor: colors.mainYallo,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_context) {
                                    TextEditingController inputName =
                                        TextEditingController();
                                    TextEditingController inputVal =
                                        TextEditingController();
                                    DateTime date = DateTime.now();
                                    String dateText = "اختر التاريخ";
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
                                                const Text("اختر نوع الوارد"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    custumeRadio("دخل ثابت",
                                                        "دخل ثابت", setState1),
                                                    custumeRadio(
                                                        "رحل و طلبات",
                                                        "رحل و طلبات",
                                                        setState1),
                                                  ],
                                                ),
                                                TextFormField(
                                                  controller: inputName,
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
                                                    hintText: "اسم الوارد",
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
                                                  controller: inputVal,
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
                                                    hintText: "قيمة الوارد",
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
                                                                        2022,
                                                                        1,
                                                                        1),
                                                                lastDate:
                                                                    DateTime(
                                                                        2050,
                                                                        1,
                                                                        1))
                                                            .then((value) {
                                                          if (value != null) {
                                                            date = value;
                                                            dateText = format
                                                                .format(date);
                                                          }

                                                          setState1(() {});
                                                        });
                                                      },
                                                      child: Text(dateText),
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
                                                          Navigator.of(_context)
                                                              .pop();
                                                          viewProvider
                                                              .customProgressDialog(
                                                                  context:
                                                                      context);
                                                          try {
                                                            await dataProvider.addNewInput(
                                                                context:
                                                                    context,
                                                                inputName:
                                                                    inputName
                                                                        .text,
                                                                inputType:
                                                                    _selected,
                                                                inputVal: double
                                                                    .parse(inputVal
                                                                        .text),
                                                                inputDate:
                                                                    date);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } on FirebaseException catch (e) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            await viewProvider
                                                                .errorDialog(
                                                                    e.code,
                                                                    context);
                                                          }
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
                            },
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
