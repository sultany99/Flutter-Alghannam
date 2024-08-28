import 'dart:io';

import 'package:alghannam_transport/data/providers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/dimantions.dart';

class NewBusView extends StatelessWidget {
  const NewBusView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController busNameController = TextEditingController();
    TextEditingController busIdController = TextEditingController();
    TextEditingController captainNameController = TextEditingController();
    TextEditingController captainNumberController = TextEditingController();
    TextEditingController captainAdrrController = TextEditingController();
    TextEditingController captainSalController = TextEditingController();
    var d = Dimantions(s: MediaQuery.of(context).size);
    var formKey = GlobalKey<FormState>();
    return Consumer2<ViewProvider, DataProvider>(
        builder: (context, viewProvider, dataProvider, child) {
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.only(
                left: d.width20 / 2,
                right: d.width20 / 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        viewProvider.toBusListView();
                      },
                      icon: Icon(Icons.arrow_forward_ios)),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل نص';
                      }
                      return null;
                    },
                    controller: busNameController,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: d.width100,
                          style: BorderStyle.solid,
                        ),
                      ),
                      hintText: "اسم الباص",
                      hintStyle: TextStyle(fontSize: d.fontSize18),
                    ),
                  ),
                  SizedBox(
                    height: d.height20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل نص';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: busIdController,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: d.width100, style: BorderStyle.solid),
                      ),
                      hintText: "رقم الباص",
                      hintStyle: TextStyle(fontSize: d.fontSize18),
                    ),
                  ),
                  SizedBox(
                    height: d.height20,
                  ),
                  const Text("معلومات السائق"),
                  SizedBox(
                    height: d.height20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل نص';
                      }
                      return null;
                    },
                    controller: captainNameController,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: d.width100, style: BorderStyle.solid),
                      ),
                      hintText: "اسم السائق",
                      hintStyle: TextStyle(fontSize: d.fontSize18),
                    ),
                  ),
                  SizedBox(
                    height: d.height20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل نص';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: captainNumberController,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: d.width100, style: BorderStyle.solid),
                      ),
                      hintText: "رقم هاتف السائق",
                      hintStyle: TextStyle(fontSize: d.fontSize18),
                    ),
                  ),
                  SizedBox(
                    height: d.height20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل نص';
                      }
                      return null;
                    },
                    controller: captainAdrrController,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: d.width100, style: BorderStyle.solid),
                      ),
                      hintText: "عنوان السائق",
                      hintStyle: TextStyle(fontSize: d.fontSize18),
                    ),
                  ),
                  SizedBox(
                    height: d.height20,
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
                    controller: captainSalController,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: d.width100, style: BorderStyle.solid),
                      ),
                      hintText: "راتب السائق",
                      hintStyle: TextStyle(fontSize: d.fontSize18),
                    ),
                  ),
                  SizedBox(
                    height: d.height20 * 2.5,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          final con = await Connectivity().checkConnectivity();
                          final result = await InternetAddress.lookup(
                              'console.firebase.google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty &&
                              !(con == ConnectivityResult.none)) {
                            viewProvider.customProgressDialog(context: context);
                            await dataProvider
                                .addNewBus(
                              context: context,
                              busName: busNameController.text,
                              busID: busIdController.text,
                              captainName: captainNameController.text,
                              captainNumber: captainNumberController.text,
                              captainAddr: captainAdrrController.text,
                              captainSal:
                                  double.parse(captainSalController.text),
                            )
                                .then((value) {
                              Navigator.of(context).pop();
                              viewProvider.toBusListView();
                              return Future(() => true);
                            });
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
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("تم"),
                        Icon(Icons.done),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: d.height20 * 2.5,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
