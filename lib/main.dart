import 'dart:io';

import 'package:alghannam_transport/android_pages/home_page.dart';
import 'package:alghannam_transport/android_pages/signIn_page.dart';
import 'package:alghannam_transport/data/providers.dart';
import 'package:alghannam_transport/views/home_view.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:alghannam_transport/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:month_year_picker/month_year_picker.dart';

//const apiKey = 'AIzaSyDcmSpPYuVebBZpcL0W2JQDhVngxFxeO2M';
//const projectId = 'alghannam-transport';
//Size size = Size(1366, 768);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseCoreForAll.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDcmSpPYuVebBZpcL0W2JQDhVngxFxeO2M",
          authDomain: "alghannam-transport.firebaseapp.com",
          projectId: "alghannam-transport",
          storageBucket: "alghannam-transport.appspot.com",
          messagingSenderId: "482759874160",
          appId: "1:482759874160:web:86b6b245d42024b9c1c6b5",
          measurementId: "G-LWPEZGCXT7"),
      firestore: true,
      auth: true,
      storage: true);
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    Size size = const Size(1366 * 0.75, 768 * 0.75);

    WindowOptions windowOptions = const WindowOptions(
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      center: true,
    );
    windowManager.setAlignment(Alignment.center);
    windowManager.setResizable(true);
    windowManager.setSize(size);
    windowManager.setIcon(
        "C:\Users\sulta\Documents\flutter\desktop\alghannam_transport\windows\runner\resources\app_icon.ico");
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en', null).then(DateFormat.yMEd);
    if (Platform.isWindows) {
      windowManager.setMinimumSize(const Size(1366 * 0.75, 768 * 0.75));
      appWindow.minSize = const Size(1366 * 0.75, 768 * 0.75);
      return MaterialApp(
        localizationsDelegates: const [
          // GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        theme: ThemeData(
          fontFamily: 'Noto_Kofi_Arabic',
          colorScheme: const ColorScheme.light(
            primary: colors.mainYallo,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: MultiProvider(providers: [
          ChangeNotifierProvider<DataProvider>(
              create: (context) => DataProvider()),
          ChangeNotifierProvider<ViewProvider>(
              create: (context) => ViewProvider()),
        ], child: const HomeView()),
      );
    } else {
      return ChangeNotifierProvider<DataProvider>(
        create: (context) => DataProvider(),
        child: MaterialApp(
          localizationsDelegates: const [
            // GlobalMaterialLocalizations.delegate,
            MonthYearPickerLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Noto_Kofi_Arabic',
            colorScheme: const ColorScheme.light(
              primary: colors.mainYallo,
            ),
          ),
          home: FirebaseAuthForAll.instance.currentUser != null
              ? const HomePage()
              : const SignIn(),
        ),
      );
    }
  }
}
