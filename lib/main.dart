import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'helper/deep_link_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupAppLinks();
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => EventController());
  Get.lazyPut(() => FavouriteController());
  Get.lazyPut(() => ForumController());
  Get.lazyPut(() => FindController());
  Get.lazyPut(() => SideMenuController());
  Get.lazyPut(() => UpdateController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'KOTA App',
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
          theme: ThemeData(useMaterial3: false, fontFamily: 'Poppins'),
        );
      },
    );
  }
}
