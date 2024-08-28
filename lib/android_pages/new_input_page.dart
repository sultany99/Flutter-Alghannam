// ignore: depend_on_referenced_packages
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:lottie/lottie.dart';
import '../data/providers.dart';
import '../utils/dimantions.dart';
import '../utils/colors.dart';

class NewInputPage extends StatefulWidget {
  const NewInputPage({super.key});

  @override
  State<NewInputPage> createState() => _NewInputPageState();
}

class _NewInputPageState extends State<NewInputPage> {
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
  TextEditingController inputName = TextEditingController();
  TextEditingController inputVal = TextEditingController();
  DateTime date = DateTime.now();
  String dateText = "اختر التاريخ";
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    DateFormat format = DateFormat('EEE , d/M/y');
    TextEditingController notes = TextEditingController();

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
            return Container(
              padding: EdgeInsets.all(d.width20),
              height: double.infinity,
              child: Form(
                key: formKey,
                child: //no radio button will be selected on initial
                    ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  addAutomaticKeepAlives: true,
                  children: [
                    SizedBox(
                      height: d.height50,
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
                        custumeRadio("دخل ثابت", "دخل ثابت", setState),
                        custumeRadio("رحل و طلبات", "رحل و طلبات", setState),
                      ],
                    ),
                    SizedBox(
                      height: d.height50,
                    ),
                    TextFormField(
                      controller: inputName,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1, //
                            style: BorderStyle.solid,
                          ),
                        ),
                        hintText: "اسم الوارد",
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
                      controller: inputVal,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1, //
                            style: BorderStyle.solid,
                          ),
                        ),
                        hintText: "قيمة الوارد",
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
                                    firstDate: DateTime(2022, 1, 1),
                                    lastDate: DateTime(2050, 1, 1))
                                .then((value) {
                              if (value != null) {
                                date = value;
                                dateText = format.format(date);
                              }

                              setState(() {});
                            });
                          },
                          child: Text(dateText,
                              style: TextStyle(fontSize: d.fontSize18)),
                        ),
                        Text("التاريخ",
                            style: TextStyle(fontSize: d.fontSize18))
                      ],
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

                              print('connected');
                              // ignore: use_build_context_synchronously
                              await dataProvider.addNewInput(
                                  context: context,
                                  inputName: inputName.text,
                                  inputType: _selected,
                                  inputVal: double.parse(inputVal.text),
                                  inputDate: date);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                              // ignore: use_build_context_synchronously
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

                          // ignore: use_build_context_synchronously
                        }
                      },
                      child:
                          Text("حفظ", style: TextStyle(fontSize: d.fontSize18)),
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
