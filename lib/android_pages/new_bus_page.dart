import 'dart:io';

import 'package:alghannam_transport/data/providers.dart';
import 'package:alghannam_transport/utils/colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firedart/firedart.dart';
import '../utils/dimantions.dart';

class NewBusPage extends StatelessWidget {
  NewBusPage({super.key});
  var formKey = GlobalKey<FormState>();
  TextEditingController busNameController = TextEditingController();
  TextEditingController busIdController = TextEditingController();
  TextEditingController captainNameController = TextEditingController();
  TextEditingController captainNumberController = TextEditingController();
  TextEditingController captainAdrrController = TextEditingController();
  TextEditingController captainSalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: d.height25 * 1.25, color: Colors.white),
        toolbarHeight: d.height100 * 0.55,
        title: Container(
          padding: EdgeInsets.only(left: d.width50),
          child: Text(
            "الغنام للنقل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: d.fontSize21),
          ),
        ),
      ),
      body: Consumer<DataProvider>(builder: (context, dataProvider, child) {
        return Stack(
          children: [
            Center(
              child:
                  Image.asset(width: d.width100 * 3, "assets/photos/25%.png"),
            ),
            Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(
                  left: d.width20,
                  right: d.width20,
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: d.height20,
                      ),
                      Text(
                        "انشاء باص \n جديد",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.mainYallo,
                          fontSize: d.fontSize21 * 2,
                          fontWeight: FontWeight.bold,
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
                      Text(
                        "معلومات السائق",
                        style: TextStyle(fontSize: d.fontSize18),
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
                              final con =
                                  await Connectivity().checkConnectivity();
                              final result = await InternetAddress.lookup(
                                  'console.firebase.google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty &&
                                  !(con == ConnectivityResult.none)) {
                                try {
                                  await FirestoreForAll.instance
                                      .collection("users")
                                      .snapshots()
                                      .listen((snapshot) async {
                                    if (snapshot.exists) {
                                      ViewProvider()
                                          .androidCustomProgressDialog(
                                              context: context);
                                      await dataProvider
                                          .addNewBus(
                                        context: context,
                                        busName: busNameController.text,
                                        busID: busIdController.text,
                                        captainName: captainNameController.text,
                                        captainNumber:
                                            captainNumberController.text,
                                        captainAddr: captainAdrrController.text,
                                        captainSal: double.parse(
                                            captainSalController.text),
                                      )
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();

                                        return Future(() => true);
                                      });
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ViewProvider().errorDialog(
                                              "لا يوجد اتصال بالخادم\n اعد المحاولة لاحقا",
                                              context);
                                        },
                                      );
                                    }
                                  }, onError: (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ViewProvider().errorDialog(
                                            "لا يوجد اتصال بالخادم\n اعد المحاولة لاحقا",
                                            context);
                                      },
                                    );
                                  });
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ViewProvider().errorDialog(
                                          "لا يوجد اتصال بالخادم \n اعد المحاولة لاحقا",
                                          context);
                                    },
                                  );
                                }
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
                          children: [
                            Text(
                              "تم",
                              style: TextStyle(fontSize: d.fontSize18),
                            ),
                            Icon(
                              Icons.done,
                              size: d.height20,
                            ),
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
          ],
        );
      }),
    );
  }
}
