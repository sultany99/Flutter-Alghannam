//DataProvider
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/colors.dart';
import 'package:lottie/lottie.dart';

import 'package:alghannam_transport/data/authentication_functions.dart';
import 'package:alghannam_transport/views/captain_Info.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:alghannam_transport/views/bus_list_view.dart';
import 'package:alghannam_transport/views/bus_view.dart';
import 'package:alghannam_transport/views/daily_gain_view.dart';
import 'package:alghannam_transport/views/default_left_view.dart';
import 'package:alghannam_transport/views/new_bus_view.dart';
import 'package:alghannam_transport/views/output_view.dart';
import 'package:alghannam_transport/views/right_side_list.dart';
import 'package:alghannam_transport/views/sign_up-in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../views/from_to_gain_view.dart';
import '../views/image_album_view.dart';
import '../views/input_view.dart';
import '../views/monthly_gain_view.dart';

class DataProvider extends ChangeNotifier {
  String? email = AuthenticationFunctions().getUser()?.email;
  String userId = AuthenticationFunctions().getUserId();
  String busId = '';
  String outputId = '';
  String inputId = '';
  String captainId = '';

  String companyLogoUrl =
      "https://firebasestorage.googleapis.com/v0/b/alghannam-transport.appspot.com/o/images%2F1080Asset%205.png?alt=media&token=fd4b1fda-1b3c-4322-a404-c0a622e9aa63";
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  DocRef<Map<String, Object?>> get getUserDocument {
    return FirestoreForAll.instance.collection("users").doc(userId);
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ColRef<Map<String, Object?>> get getUsersCollectio {
    return FirestoreForAll.instance.collection("users");
  }

  set setCaptainId(id) {
    captainId = id;
    notifyListeners();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  updateProfileImage(r) {
    DataProvider()
        .getBusListCollectionReference
        .doc(busId)
        .update({"mainImage": r}).then((value) => notifyListeners());
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ColRef<Map<String, Object?>> get getBusListCollectionReference =>
      getUserDocument.collection("busses");
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ColRef<Map<String, Object?>> get getImagesCollectionReference =>
      getBusListCollectionReference.doc(busId).collection("images");
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ColRef<Map<String, Object?>> get getInputsCollectionReference =>
      getBusListCollectionReference.doc(busId).collection("inputs");
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  DocRef<Map<String, Object?>> get getIntputDocumentReference =>
      getInputsCollectionReference.doc(inputId);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ColRef<Map<String, Object?>> get getOutputsCollectionReference =>
      getBusListCollectionReference.doc(busId).collection("outputs");
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  DocRef<Map<String, Object?>> get getOutputDocumentReference =>
      getOutputsCollectionReference.doc(outputId);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<DocRef<Map<String, Object?>>>
      get getCaptainInfoDocumentReference async {
    QuerySnapshotForAll<Map<String, Object?>> captainCollection =
        await getBusListCollectionReference
            .doc(busId)
            .collection("captain info")
            .get();
    return captainCollection.docs.first.ref;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  deleteBus({required BuildContext context}) async {
    await getBusListCollectionReference
        .doc(busId)
        .collection("images")
        .get()
        .then((value) async {
      if (value.exists) {
        for (DocumentSnapshotForAll<Map<String, Object?>> element
            in value.docs) {
          await FirebaseStorageForAll.instance
              .ref()
              .child(element["imagePath"])
              .delete();
          await element.ref.delete();
        }
      }
    });
    await getBusListCollectionReference
        .doc(busId)
        .collection("captainInfo")
        .get()
        .then((value) async {
      if (value.exists) {
        await value.docs.first.ref
            .collection("images")
            .get()
            .then((value) async {
          if (value.exists) {
            for (DocumentSnapshotForAll<Map<String, Object?>> element
                in value.docs) {
              await FirebaseStorageForAll.instance
                  .ref()
                  .child(element["imagePath"])
                  .delete();
              await element.ref.delete();
            }
          }
        });
      }
    });
    await getBusListCollectionReference.doc(busId).delete();
    busId = '';
    captainId = '';
    inputId = '';
    outputId = '';

    if (Platform.isWindows) notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Add New Output -------------------------------------------------------------------------
  addNewInput({
    required BuildContext context,
    required String inputName,
    required String inputType,
    required double inputVal,
    required DateTime inputDate,
  }) async {
    DateTime path = DateUtils.dateOnly(inputDate);

    double userOldGain = 0;
    double userInputVal = inputVal;
    double oldGain = 0;
    print('dddddddddddddddddddddddddd');
    //FETCH DATA

    //user daily gain
    if (Platform.isWindows) {
      await getUserDocument
          .collection('dailyGain')
          .doc('$path')
          .update({"Date": path});
    }

    DocRef<Map<String, Object?>> userDailyGain =
        getUserDocument.collection('dailyGain').doc('$path');
    //bus daily gain
    if (Platform.isWindows) {
      await getBusListCollectionReference
          .doc(busId)
          .collection('dailyGain')
          .doc('$path')
          .update({"Date": path});
    }

    DocRef<Map<String, Object?>> busDailyGain = getBusListCollectionReference
        .doc(busId)
        .collection('dailyGain')
        .doc('$path');
    await userDailyGain.get().then((value) async {
      if (value.exists) {
        if (value['Value'] != null) userOldGain = value['Value'];
      }
    });
    await busDailyGain.get().then((value) async {
      if (value.exists && value['Value'] != null) {
        oldGain = value['Value'];
      }
    });

    //LOGIC OPERATIONS
    userOldGain = userOldGain + userInputVal;
    oldGain = oldGain + inputVal;

    //UPLOAD DATA
    print("k");
    userDailyGain.set({'Value': userOldGain, "Date": path});
    getBusListCollectionReference
        .doc(busId)
        .collection('dailyGain')
        .doc('$path')
        .set({'Value': oldGain, "Date": path});
    getInputsCollectionReference.add({
      "Name": inputName,
      "Value": inputVal,
      "Date": path,
      "Type": inputType,
    });
    print("k1");

    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Add New Output -------------------------------------------------------------------------
  addNewOutput({
    required BuildContext context,
    required String outputName,
    required String outputType,
    required DateTime outputDate,
    required double outputVal,
  }) async {
    String captainName = '';
    DateTime thisMonth = DateTime(outputDate.year, outputDate.month, 1);
    DateTime path = DateUtils.dateOnly(outputDate);

    double captainPaysVal = 0;
    double userOldGain = 0;
    double userOutputVal = outputVal;
    double oldGain = 0;

    if (outputType == "سلف السائق") {
      await getBusListCollectionReference
          .doc(busId)
          .collection('captainInfo')
          .get()
          .then((value) {
        captainName = value.docs.first["captainName"].toString();
      });
      if (Platform.isWindows) {
        await getBusListCollectionReference
            .doc(busId)
            .collection('captainPays')
            .doc(captainName)
            .collection('monthly')
            .doc('$thisMonth')
            .update({"Date": thisMonth});
      }

      DocRef<Map<String, Object?>> captainPaysDoc =
          getBusListCollectionReference
              .doc(busId)
              .collection('captainPays')
              .doc(captainName)
              .collection('monthly')
              .doc('$thisMonth');

      captainPaysDoc.get().then((value) async {
        if (value.exists) {
          if (value["value"] != null) {
            captainPaysVal = double.parse(value["value"].toString());
          }
        }
      });
    }
    //user daily gain
    if (Platform.isWindows) {
      await getUserDocument
          .collection('dailyGain')
          .doc('$path')
          .update({"Date": path});
    }

    DocRef<Map<String, Object?>> userDailyGain =
        getUserDocument.collection('dailyGain').doc('$path');
    //bus daily gain
    if (Platform.isWindows) {
      await getBusListCollectionReference
          .doc(busId)
          .collection('dailyGain')
          .doc('$path')
          .update({"Date": path});
    }

    DocRef<Map<String, Object?>> busDailyGain = getBusListCollectionReference
        .doc(busId)
        .collection('dailyGain')
        .doc('$path');

    await userDailyGain.get().then((value) async {
      if (value.exists && value['Value'] != null) {
        userOldGain = double.parse(value['Value'].toString());
      }
    });

    await busDailyGain.get().then((value) async {
      if (value.exists && value['Value'] != null) {
        oldGain = double.parse(value['Value'].toString());
      }
    });

    //LOGIC OPERATIONS
    oldGain = oldGain - outputVal;
    userOldGain = userOldGain - userOutputVal;

    //UPLOAD DATA
    if (outputType == "سلف السائق") {
      getBusListCollectionReference
          .doc(busId)
          .collection('captainPays')
          .doc(captainName)
          .collection('monthly')
          .doc('$thisMonth')
          .set({'value': captainPaysVal + outputVal, "Date": path});
    }
    userDailyGain.set({'Value': userOldGain, "Date": path});
    getBusListCollectionReference
        .doc(busId)
        .collection('dailyGain')
        .doc('$path')
        .set({'Value': oldGain, "Date": path});
    getOutputsCollectionReference.add({
      "Name": outputName,
      "Value": outputVal,
      "Date": path,
      "Type": outputType,
    });

    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<double> getDailyGain({
    required BuildContext context,
    required DateTime dailyGainDate,
    required ColRef<Map<String, Object?>> dailyGainColReference,
  }) async {
    double gain = 0;
    String path = DateUtils.dateOnly(dailyGainDate).toString();
    print(path);
    await dailyGainColReference.doc(path).get().then((value) {
      if (value.exists && value.data()?["Value"] != null) {
        print("l1");
        gain = double.parse(value["Value"].toString());
      } else {
        print("l2");
        gain = 0;
      }
    });

    return gain;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<double> getMonthlyGain({
    required BuildContext context,
    required DateTime monthlyGainDate,
    required ColRef<Map<String, Object?>> dailyGainColReference,
  }) async {
    double gain = 0;

    DateTime start = DateTime(monthlyGainDate.year, monthlyGainDate.month, 01);
    DateTime end =
        DateTime(monthlyGainDate.year, monthlyGainDate.month + 1, 01);
    double montlyGain = 0;
    await dailyGainColReference.get().then((value) async {
      if (value.exists) {
        for (DocumentSnapshotForAll<Map<String, Object?>> element
            in value.docs) {
          if (element.exists) {
            if (Platform.isAndroid) {
              if ((start.isBefore(element["Date"].toDate()) &&
                      end.isAfter(element["Date"].toDate())) ||
                  start.isAtSameMomentAs(element["Date"].toDate())) {
                if (element['Value'] != null) {
                  double v = element['Value'];
                  montlyGain += v;
                }
              }
            } else if (Platform.isWindows) {
              if ((start.isBefore(element["Date"]) &&
                      end.isAfter(element["Date"])) ||
                  start.isAtSameMomentAs(element["Date"])) {
                if (element['Value'] != null) {
                  double v = element['Value'];
                  montlyGain += v;
                }
              }
            }
          }
        }

        gain = montlyGain;
      } else {
        gain = 0;
      }
    });

    return gain;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<Map<dynamic, dynamic>> getFromToGain({
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
    required ColRef<Map<String, Object?>> dailyGainColReference,
  }) async {
    DateTime dateTime = startDate;
    Map<DateTime, double> check = {};
    List<DailyGain> gainList = [];
    double gain = 0;

    double fromToGain = 0;
    await dailyGainColReference.get().then((value) async {
      if (value.exists) {
        if (Platform.isAndroid) {
          for (var element in value.docs) {
            if (element.exists) {
              if (startDate.isAtSameMomentAs(element["Date"].toDate()) ||
                  endDate.isAtSameMomentAs(element["Date"].toDate())) {
                double v = 0;
                if (element['Value'] != null) {
                  v = element['Value'];
                }
                fromToGain += v;
                check[element["Date"].toDate()] = 100;
                gainList
                    .add(DailyGain(value: v, date: element["Date"].toDate()));
                dateTime = dateTime.add(const Duration(days: 1));
              } else if (startDate.isBefore(element["Date"].toDate()) &&
                  endDate.isAfter(element["Date"].toDate())) {
                double v = 0;
                if (element['Value'] != null) {
                  v = element['Value'];
                }
                fromToGain += v;
                check[element["Date"].toDate()] = 100;
                gainList
                    .add(DailyGain(value: v, date: element["Date"].toDate()));

                while (dateTime.isBefore(element["Date"].toDate())) {
                  if (check[dateTime] == 100) {
                    dateTime = dateTime.add(const Duration(days: 1));
                  } else {
                    check[dateTime] = 100;
                    gainList.add(DailyGain(value: 0, date: dateTime));
                    dateTime = dateTime.add(const Duration(days: 1));
                  }
                }
              }
            }
          }
        } else if (Platform.isWindows) {
          for (var element in value.docs) {
            if (element.exists) {
              if (startDate.isAtSameMomentAs(element["Date"]) ||
                  endDate.isAtSameMomentAs(element["Date"])) {
                double v = 0;
                if (element['Value'] != null) {
                  v = element['Value'];
                }
                fromToGain += v;
                check[element["Date"]] = 100;
                gainList.add(DailyGain(value: v, date: element["Date"]));
                dateTime = dateTime.add(const Duration(days: 1));
              } else if (startDate.isBefore(element["Date"]) &&
                  endDate.isAfter(element["Date"])) {
                double v = 0;
                if (element['Value'] != null) {
                  v = element['Value'];
                }
                fromToGain += v;
                check[element["Date"]] = 100;
                gainList.add(DailyGain(value: v, date: element["Date"]));

                while (dateTime.isBefore(element["Date"])) {
                  if (check[dateTime] == 100) {
                    dateTime = dateTime.add(const Duration(days: 1));
                  } else {
                    check[dateTime] = 100;
                    gainList.add(DailyGain(value: 0, date: dateTime));
                    dateTime = dateTime.add(const Duration(days: 1));
                  }
                }
              }
            }
          }
        }
        while (dateTime.isBefore(endDate)) {
          if (check[dateTime] == 100) {
            dateTime = dateTime.add(const Duration(days: 1));
          } else {
            check[dateTime] = 100;
            gainList.add(DailyGain(value: 0, date: dateTime));
            dateTime = dateTime.add(const Duration(days: 1));
          }
        }

        gain = fromToGain;
      } else {
        gain = 0;
      }
    });

    if (kDebugMode) {
      print("gain = $gain  ");
    }
    for (DailyGain element in gainList) {
      if (kDebugMode) {
        print("value: ${element.value},Date: ${element.date}");
      }
    }
    return {"gain": gain, "gainList": gainList};
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  deleteOutput({
    required BuildContext context,
  }) async {
    double oldGain = 0;
    double oldPay = 0;
    if (kDebugMode) {
      print('\n deleting ..... \n');
    }
    var outputDate1;
    double outputVal = 0;
    String outputType = '';
    String captainName = '';
    DocRef<Map<String, Object?>> thisOutput = getOutputDocumentReference;
    print(thisOutput);
    await thisOutput.get().then((value) {
      outputVal = double.parse(value['Value'].toString());
      outputType = value['Type'];
      outputDate1 = Platform.isWindows ? value['Date'] : value['Date'].toDate();
    });
    outputDate1 = DateUtils.dateOnly(outputDate1);
    await getUserDocument
        .collection('dailyGain')
        .doc(outputDate1.toString())
        .get()
        .then((value) {
      oldGain = double.parse(value['Value'].toString());
      oldGain += outputVal;
    });
    await getBusListCollectionReference
        .doc(busId)
        .collection("dailyGain")
        .doc(outputDate1.toString())
        .get()
        .then((value) async {
      double oldGain = double.parse(value['Value'].toString());
      oldGain += outputVal;
      value.ref.update({'Value': oldGain});
      if (outputType == 'سلف السائق') {
        await getBusListCollectionReference
            .doc(busId)
            .collection('captainInfo')
            .get()
            .then((value) {
          captainName = value.docs.first['captainName'];
        });
        await getBusListCollectionReference
            .doc(busId)
            .collection('captainPays')
            .doc(captainName)
            .collection('monthly')
            .doc('${DateTime(outputDate1.year, outputDate1.month, 1)}')
            .get()
            .then((value1) async {
          oldPay = double.parse(value1['value'].toString());
          oldPay -= outputVal;
        });
      }
    });
    getUserDocument
        .collection('dailyGain')
        .doc(outputDate1.toString())
        .update({'Value': oldGain});
    if (outputType == 'سلف السائق') {
      getBusListCollectionReference
          .doc(busId)
          .collection('captainPays')
          .doc(captainName)
          .collection('monthly')
          .doc('${DateTime(outputDate1.year, outputDate1.month, 1)}')
          .update({'value': oldPay});
    }

    thisOutput.delete();

    outputId = '';
    if (Platform.isAndroid) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else if (Platform.isWindows) {
      notifyListeners();
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  deleteInput({
    required BuildContext context,
  }) async {
    print('\n deleting ..... \n');
    var inputDate1;
    double oldGain = 0;
    double oldPay = 0;
    double inputVal = 0;
    String inputType = '';
    String captainName = '';
    DocRef<Map<String, Object?>> thisInput = getIntputDocumentReference;
    print(thisInput);
    await thisInput.get().then((value) {
      inputVal = value['Value'];
      inputType = value['Type'];
      inputDate1 = Platform.isWindows ? value['Date'] : value['Date'].toDate();
    });
    inputDate1 = DateUtils.dateOnly(inputDate1);
    print(inputDate1);
    await getUserDocument
        .collection('dailyGain')
        .doc(inputDate1.toString())
        .get()
        .then((value) {
      if (value.exists) oldGain = double.parse(value['Value'].toString());
      oldGain -= inputVal;
    });
    await getBusListCollectionReference
        .doc(busId)
        .collection("dailyGain")
        .doc('$inputDate1')
        .get()
        .then((value) async {
      if (value.exists) oldPay = double.parse(value['Value'].toString());
      oldPay -= inputVal;
    });

    getBusListCollectionReference
        .doc(busId)
        .collection("dailyGain")
        .doc('$inputDate1')
        .update({'Value': oldPay});
    getUserDocument
        .collection('dailyGain')
        .doc(inputDate1.toString())
        .update({'Value': oldGain});
    thisInput.delete();

    inputId = '';
    if (Platform.isAndroid) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else if (Platform.isWindows) {
      notifyListeners();
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future uploadImages({
    required BuildContext context,
    required String imageAlbumName,
    required ColRef<Map<String, Object?>> imageAlbumReference,
  }) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      // ignore: use_build_context_synchronously
      ProgressDialog pd = ProgressDialog(
          backgroundColor: Colors.white10,
          context: context,
          textColor: Colors.orange);
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => pd,
      );

      await getBusListCollectionReference.get().then(
        (value) async {
          if (!value.exists) {
            showDialog(
              context: context,
              builder: (context) {
                Navigator.of(context).pop();
                return ViewProvider().errorDialog(
                    "لا يوجد اتصال بالخادم!!! , اعد المحاولة لاحقا", context);
              },
            );
          } else {
            for (PlatformFile element in result.files) {
              String? filePath = element.path;
              File file = File(filePath ?? '');
              StorageRef storeImage = FirebaseStorageForAll.instance
                  .ref()
                  .child('images')
                  .child(imageAlbumName)
                  .child(element.name);

              try {
                storeImage
                    .putFile(
                      file,
                    )
                    .snapshotEvents
                    .listen((taskSnapshot) async {
                  switch (taskSnapshot.state) {
                    case TaskState.running:
                      break;
                    case TaskState.paused:
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => ViewProvider().errorDialog(
                            "لقد توقف التحميل!!! . حاول لاحقا", context),
                      );
                      break;
                    case TaskState.success:
                      print("done uploading");
                      await storeImage.getDownloadURL().then((p0) async {
                        ColRef<Map<String, Object?>> cl = imageAlbumReference;
                        if (kDebugMode) {
                          print(p0);
                        }
                        cl.add(
                            {'imageURL': p0, 'imagePath': storeImage.fullPath});
                      });

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();

                      break;
                    case TaskState.canceled:
                      Navigator.of(context).pop();

                      showDialog(
                        context: context,
                        builder: (context) => ViewProvider().errorDialog(
                            "لقد توقف التحميل!!! . حاول لاحقا", context),
                      );
                      break;
                    case TaskState.error:
                      Navigator.of(context).pop();

                      showDialog(
                        context: context,
                        builder: (context) => ViewProvider().errorDialog(
                            "لقد توقف التحميل!!! . حاول لاحقا", context),
                      );
                      break;
                  }
                });
              } catch (e) {
                if (kDebugMode) {
                  print(e.toString());
                }
              }
            }
          }
        },
      );
    } else {
      // User canceled the picker
    }
    notifyListeners();
    return Future;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  getBusData(context) async {
    Map busData = {};

    await getBusListCollectionReference.doc(busId).get().then((snapShot) async {
      await snapShot.ref
          .collection("captainInfo")
          .get()
          .then((snapShot2) async {
        print(snapShot2.docs.single.exists);
        busData["busName"] = snapShot.data()?["busName"];
        busData["busId"] = snapShot.data()?["busId"];
        busData["captanName"] = snapShot2.docs.first["captainName"];
        busData["captanAddr"] = snapShot2.docs.first["captainAddr"];
        busData["captanNumber"] = snapShot2.docs.first["captainNumber"];
        busData["captainSal"] = snapShot2.docs.first["captainSal"];
      });
    });

    return busData;
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  deleteImage(
    DocumentSnapshotForAll<Map<String, Object?>> imageSnapshot,
    context,
  ) async {
    await getBusListCollectionReference.doc(busId).get().then((value) async {
      if (!value.exists) {
        showDialog(
          context: context,
          builder: (context) {
            Navigator.of(context).pop();
            return ViewProvider().errorDialog(
                "لا يوجد اتصال بالخادم!!! , اعد المحاولة لاحقا", context);
          },
        );
      } else {
        if (imageSnapshot["imageURL"] == value.data()?["mainImage"]) {
          getBusListCollectionReference
              .doc(busId)
              .update({"mainImage": companyLogoUrl});
        }
        await imageSnapshot.ref.delete();
        await FirebaseStorageForAll.instance
            .ref()
            .child(imageSnapshot["imagePath"])
            .delete();
      }
    });
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  get getBusId => busId;
  setBusId(bId) {
    busId = bId;
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  setOutputId(oId) {
    outputId = oId;
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  setInputId(oId) {
    inputId = oId;
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  clear() {
    inputId = '';
    outputId = '';
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  updateBus({
    required BuildContext context,
    required String busName,
    required String busID,
    required String captainName,
    required String captainNumber,
    required String captainAddr,
    required double captainSal,
  }) async {
    await getBusListCollectionReference.doc(busId).update({
      'busName': busName,
      'busId': busID,
      'notes': '',
    }).then((value) async {
      await getBusListCollectionReference
          .doc(busId)
          .collection("captainInfo")
          .get()
          .then((value) async {
        print('k2');
        await value.docs.first.ref.update({
          'captainName': captainName,
          'captainAddr': captainAddr,
          'captainNumber': captainNumber,
          'captainSal': captainSal,
        }).then((value) {
          print("done");
        });
      });
    });

    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<bool> addNewBus({
    required BuildContext context,
    required String busName,
    required String busID,
    required String captainName,
    required String captainNumber,
    required String captainAddr,
    required num captainSal,
  }) async {
    await getBusListCollectionReference.add({
      'busName': busName,
      'busId': busID,
      'mainImage': companyLogoUrl,
      'notes': '',
    }).then((value) {
      value.collection("captainInfo").add({
        'captainName': captainName,
        'captainAddr': captainAddr,
        'captainNumber': captainNumber,
        'captainSal': captainSal,
      }).then((value) {
        print("done");
      });
    });

    notifyListeners();
    return Future(() => true);
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ViewProvider extends ChangeNotifier {
  Widget homeLeftSide = DefaultLeftView();
  Widget homeRightSide = FirebaseAuthForAll.instance.currentUser != null
      ? const RightSideListView()
      : const SignIn();
  toBusPage() {
    homeLeftSide = const BusView();
    notifyListeners();
  }

  toNewBusView() {
    homeRightSide = const NewBusView();
    notifyListeners();
  }

  toDailyGainView(
      ColRef<Map<String, Object?>> dailyGainColReference, bool backHome) {
    homeLeftSide = DailyGainView(
      dailyGainColReference: dailyGainColReference,
      backHome: backHome,
    );
    notifyListeners();
  }

  toMonthlyGainView(
      ColRef<Map<String, Object?>> dailyGainColReference, bool backHome) {
    homeLeftSide = MonthlyGainView(
      dailyGainColReference: dailyGainColReference,
      backHome: backHome,
    );
    notifyListeners();
  }

  toImageAlbumView({
    required ColRef<Map<String, Object?>> imageAlbumReference,
    required String folderName,
    required bool canBeProfile,
  }) {
    homeLeftSide = ImageAlbumView(
      imageAlbumReference: imageAlbumReference,
      folderName: folderName,
      canBeProfile: canBeProfile,
    );
    notifyListeners();
  }

  toFromToGainView(
    dailyGainColReference,
    backHome,
  ) {
    homeLeftSide = FromToGainView(
      dailyGainColReference: dailyGainColReference,
      backHome: backHome,
    );
    notifyListeners();
  }

  toOutputsView() {
    homeLeftSide = const OutputView();
    notifyListeners();
  }

  toInputsView() {
    homeLeftSide = const InputView();
    notifyListeners();
  }

  toDefaultLeft() {
    homeLeftSide = DefaultLeftView();
    notifyListeners();
  }

  toRightSideList() {
    homeRightSide = const RightSideListView();
    notifyListeners();
  }

  toBusListView() {
    homeRightSide = const BusListView();
    notifyListeners();
  }

  toCaptainInfoView() {
    homeLeftSide = CaptainInfo();
    notifyListeners();
  }

  toSignUp() {
    homeRightSide = const SignUp();
    notifyListeners();
  }

  toSignIn() {
    homeRightSide = const SignIn();
    notifyListeners();
  }

  errorDialog(String e, context) {
    return Dialog(
      child: Container(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        height: 225,
        width: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "!!!تنبيه",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: colors.mainYallo),
            ),
            Text(
              e,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: const Text("موافق")),
          ],
        ),
      ),
    );
  }

  customProgressDialog({required BuildContext context}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
              child: LottieBuilder.asset(
                  height: 140, "assets/lottie/alghannamProgressInd.json"));
        });
  }

  androidCustomProgressDialog({required BuildContext context}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
              child: LottieBuilder.asset(
                  height: 100, "assets/lottie/alghannamProgressInd.json"));
        });
  }
}

class DailyGain {
  double value;
  DateTime date;
  DailyGain({required this.value, required this.date});
}
