

import 'package:get/get.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/controller/network_controller.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:kota/controller/user_controller.dart';

Future<void> initializeControllers()async {
  Get.put(AuthController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => EventController());
  Get.lazyPut(() => FavouriteController());
  Get.lazyPut(() => ForumController());
  Get.lazyPut(() => FindController());
  Get.lazyPut(() => SideMenuController());
  Get.lazyPut(() => UpdateController());
  Get.put(NetworkController());

  await Get.find<AuthController>().initSession(); 
}
