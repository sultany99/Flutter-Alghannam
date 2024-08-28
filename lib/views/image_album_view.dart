import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/providers.dart';
import '../utils/dimantions.dart';
import '../utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class ImageAlbumView extends StatefulWidget {
  ColRef<Map<String, Object?>> imageAlbumReference;
  String folderName;
  bool canBeProfile = true;
  ImageAlbumView({
    super.key,
    required this.imageAlbumReference,
    required this.folderName,
    required this.canBeProfile,
  });

  @override
  State<ImageAlbumView> createState() => _ImageAlbumViewState();
}

class _ImageAlbumViewState extends State<ImageAlbumView> {
  @override
  Widget build(BuildContext context) {
    var d = Dimantions(s: MediaQuery.of(context).size);

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
              final imagesAlbumReference = FirebaseStorageForAll.instance
                  .ref()
                  .child('images')
                  .child(widget.folderName);
              try {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(Icons.refresh)),
                        IconButton(
                            onPressed: () async {
                              await dataProvider
                                  .uploadImages(
                                context: context,
                                imageAlbumName: widget.folderName,
                                imageAlbumReference: widget.imageAlbumReference,
                              )
                                  .then((value) {
                                setState(() {});
                              }, onError: (e) {});
                            },
                            icon: const Icon(Icons.add)),
                        IconButton(
                            onPressed: () {
                              widget.canBeProfile
                                  ? viewProvider.toBusPage()
                                  : viewProvider.toCaptainInfoView();
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: widget.imageAlbumReference.get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: LottieBuilder.asset(
                                  height: 60,
                                  "assets/lottie/alghannamProgressInd.json"),
                            );
                          } else {
                            return GridView.builder(
                              itemCount: snapshot.data?.size,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Container(
                                              color: const Color.fromARGB(
                                                  255, 255, 190, 121),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  d.height200 * 0.90,
                                              child: Flex(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                direction: Axis.vertical,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(Icons
                                                        .arrow_forward_ios),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            d.height100 * 2,
                                                    child: Image.network(
                                                      snapshot.data?.docs
                                                              .elementAt(index)[
                                                          "imageURL"],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      widget.canBeProfile
                                                          ? ElevatedButton(
                                                              onPressed: () {
                                                                dataProvider.updateProfileImage(snapshot
                                                                        .data?.docs
                                                                        .elementAt(
                                                                            index)[
                                                                    "imageURL"]);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  "ضبط كصورة بروفايل"))
                                                          : Container(),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Dialog(
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 20,
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            20),
                                                                    height: 225,
                                                                    width: 350,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        const Text(
                                                                          "!!!تنبيه",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 25,
                                                                              color: colors.mainYallo),
                                                                        ),
                                                                        const Text(
                                                                          "هل تريد حذف الصورة ؟",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                        const Text(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          "ملاحظة:عند حذف الصورة لن تكون قادر على استرجاعها",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 10,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            ElevatedButton(
                                                                                onPressed: () async {
                                                                                  await dataProvider.getBusListCollectionReference.get().then(
                                                                                    (value) async {
                                                                                      if (!value.exists) {
                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (context) {
                                                                                            return viewProvider.errorDialog("لا يوجد اتصال بالخادم!!! , اعد المحاولة لاحقا", context);
                                                                                          },
                                                                                        );
                                                                                      } else {
                                                                                        await dataProvider.deleteImage(snapshot.data!.docs.elementAt(index), context);
                                                                                        Navigator.of(context).pop();
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                },
                                                                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                                                                                child: const Text("موافق")),
                                                                            ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text("رجوع")),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                            /* */
                                                          },
                                                          child: const Text(
                                                              "حذف الصورة")),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                        color: const Color.fromARGB(
                                            255, 255, 190, 121),
                                        child: Container(
                                            padding:
                                                EdgeInsets.all(d.height20 / 7),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                width: 1,
                                                color: colors.mainYallo,
                                              ),
                                            ),
                                            height: d.height100 * 2.5,
                                            width: d.height100 * 2.5,
                                            child: Image.network(
                                                snapshot.data?.docs.elementAt(
                                                    index)["imageURL"]))));
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              } on FirebaseException catch (e) {
                print(e.code);
                return Center(
                  child: Column(
                    children: [
                      const Text("لا يوجد اتصال"),
                      IconButton(
                          onPressed: () => setState(() {}),
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
