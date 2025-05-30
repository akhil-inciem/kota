import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/network_controller.dart';
import 'package:kota/controller_initializer.dart';
import 'package:kota/views/network/network_wrapper.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:kota/views/network/no_internet_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences and controllers
  final prefs = await SharedPreferences.getInstance();
  await initializeControllers();

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
          theme: ThemeData(useMaterial3: false, fontFamily: 'Poppins'),
          home: LoginScreen(), // Add this
          builder: (context, child) {
            return NetworkWrapper(child: child!);
          },
        );
      },
    );
  }
}
