import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorpforce/config/app_routes.dart';
import 'package:scorpforce/data/local/objectbox.dart';
import 'package:scorpforce/utils/get_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? pref;
late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  pref = await SharedPreferences.getInstance();

  if (pref!.getBool('is_not_first_run') == null) {
    await pref!.clear();
    pref = await SharedPreferences.getInstance();
    await pref!.setBool('is_not_first_run', true);
  }

  objectBox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ScreenUtilInit(
        designSize: const Size(412, 732),
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  // const InternetConnectionDialog(),
                ],
              );
            },
            color: context.theme.colorScheme.primary,
            debugShowCheckedModeBanner: false,
            getPages: getPages,
            initialRoute: AppRoutes.splashScreen,
          );
        },
      ),
    );
  }
}
