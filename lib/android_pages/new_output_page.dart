import 'dart:io';

import 'package:alghannam_transport/data/providers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/dimantions.dart';

class NewOutputPage extends StatefulWidget {
  const NewOutputPage({super.key});

  @override
  State<NewOutputPage> createState() => _NewOutputPageState();
}

class _NewOutputPageState extends State<NewOutputPage> {
  TextEditingController outputName = TextEditingController();
  TextEditingController outputVal = TextEditingController();
  DateTime date = DateTime.now();
  String pickedDate = "اختر التاريخ";
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
          fontSize: 18,
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

    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                SizedBox(width: d.height100 * 0.55),
              ],
              iconTheme:
                  IconThemeData(size: d.height25 * 1.25, color: Colors.white),
              toolbarHeight: d.height100 * 0.55,
              title: Center(
                child: Text(
                  "الغنام للنقل",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: d.fontSize21),
                ),
              ),
            ),
            body: Stack(children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  width: d.width100 * 3,
                  "assets/photos/25%.png",
                ),
              ),
              Container(
                padding: EdgeInsets.all(d.width20),
                height: double.infinity,
                child: Form(
                  key: formKey,
                  child: //no radio button will be selected on initial
                      ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      SizedBox(
                        height: d.height25,
                      ),
                      Text(
                        "اختر نوع الوارد",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: d.fontSize18,
                        ),
                      ),
                      SizedBox(
                        height: d.height25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              custumeRadio(
                                  "سلف السائق", "سلف السائق", setState),
                              SizedBox(
                                height: d.height20 / 2,
                              ),
                              custumeRadio("صيانة", "صيانة", setState),
                            ],
                          ),
                          Column(
                            children: [
                              custumeRadio("مخالفات", "مخالفات", setState),
                              SizedBox(
                                height: d.height20 / 2,
                              ),
                              custumeRadio("مازوت", "مازوت", setState),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: d.height25,
                      ),
                      TextFormField(
                        controller: outputName,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1, //
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "اسم المدفوع",
                          hintStyle: TextStyle(fontSize: d.fontSize18),
                        ),
                      ),
                      SizedBox(
                        height: d.height25,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'ادخل نص';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'ادخل ارقام فقط';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: outputVal,
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1, //
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: "قيمة المدفوع",
                          hintStyle: TextStyle(fontSize: d.fontSize18),
                        ),
                      ),
                      SizedBox(
                        height: d.height25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: date,
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
                          Text(
                            "التاريخ",
                            style: TextStyle(
                              fontSize: d.fontSize18,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: d.height25,
                      ),
                      SizedBox(
                        height: d.height25,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              final con =
                                  await Connectivity().checkConnectivity();
                              final result = await InternetAddress.lookup(
                                  'console.firebase.google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty &&
                                  !(con == ConnectivityResult.none)) {
                                ViewProvider().androidCustomProgressDialog(
                                    context: context);
                                try {
                                  await dataProvider.addNewOutput(
                                      context: context,
                                      outputName: outputName.text,
                                      outputType: _selected,
                                      outputDate: date,
                                      outputVal: double.parse(outputVal.text));
                                  // ignore: nullable_type_in_catch_clause
                                } catch (e) {
                                  await ViewProvider()
                                      .errorDialog(e.toString(), context);
                                }
                                Navigator.of(context).pop();
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
                          }
                          // ignore: use_build_context_synchronously

                          _selected = "نوع غير معروف";
                          setState(() {});
                        },
                        child: Text(
                          "حفظ",
                          style: TextStyle(
                            fontSize: d.fontSize18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]));
      },
    );
  }
}
