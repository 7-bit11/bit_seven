import 'dart:io';

import 'package:bit_seven/frame.dart';
import 'package:bit_seven/utils/material_Color.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:bit_seven/pages/LoginPage.dart';
import 'package:bit_seven/utils/status_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/service_result.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StatusBar.setBarStatus(true);
  var boolx = await isCacheData();
  runApp(MyApp(boolx));
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(600, 450);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "Custom window with Flutter";
      win.show();
    });
  }
}

Future<bool> isCacheData() async {
  final shared = await SharedPreferences.getInstance();
  try {
    String islogin = shared.getString("token")!;
    if (islogin.isNotEmpty) {
      //请求头初始化
      ServiceTokenHead.initializationHead(islogin);
      return true;
    }
    // ignore: empty_catches
  } catch (e) {}
  return false;
}

class MyApp extends StatelessWidget {
  const MyApp(this.boolx, {super.key});
  final bool boolx;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return
    // AdaptiveTheme(
    //     light: ThemeData(
    //       brightness: Brightness.light,
    //       primarySwatch: Colors.red,
    //     ),
    //     dark: ThemeData(
    //       brightness: Brightness.dark,
    //       primarySwatch: Colors.red,
    //     ),
    //     initial: AdaptiveThemeMode.dark,
    //     builder: (theme, darkTheme) => GetMaterialApp(
    //           title: '7_bit',
    //           // theme: ThemeData(
    //           //     fontFamily: "alimm",
    //           //     primarySwatch: createMaterialColor(
    //           //         const Color.fromARGB(0, 255, 255, 255)),
    //           //     highlightColor: Colors.transparent,
    //           //     splashColor: Colors.transparent),
    //           home: boolx ? FramePage() : LoginPage(),
    //           builder: EasyLoading.init(),
    //         ));
    return GetMaterialApp(
      title: '7_bit',
      theme: ThemeData(
          fontFamily: "alimm",
          primarySwatch:
              createMaterialColor(const Color.fromARGB(0, 255, 255, 255)),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent),
      home: Platform.isWindows
          ? WindowBorder(
              color: Colors.blue,
              child: boolx ? FramePage() : LoginPage(),
            )
          : boolx
              ? FramePage()
              : LoginPage(),
      builder: EasyLoading.init(),
    );
  }
}
