import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'views/splash_screen.dart';

void main() {
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => EventController());
  Get.lazyPut(() => FavouriteController());
  Get.lazyPut(() => ForumController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'MVC GetX App',
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
          theme: ThemeData(useMaterial3: false, fontFamily: 'Poppins'),
        );
      },
    );
  }
}
