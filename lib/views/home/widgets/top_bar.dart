import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/views/drawer/drawer_screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TopBar extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final Color? iconColor;
  final String? leadingIcon;
  final bool? guest;

  TopBar({this.title, this.onTap, this.iconColor, this.leadingIcon, this.guest});

  final HomeController homeController = Get.find<HomeController>();

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Event Calendar';
      case 2:
        return 'Forum';
      case 3:
        return 'Favorites';
      case 4:
        return 'Updates';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int currentIndex = homeController.index.value;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentIndex == 0 && title == null)
              SvgPicture.asset('assets/images/KOTA_Logo.svg', width: 100)
            else
              Row(
                children: [
                  InkWell(
                    onTap: onTap ?? () => homeController.index.value = 0,
                    child: Image.asset(
                      leadingIcon ?? 'assets/icons/backbutton.png',
                      width: 24,
                      height: 24,
                      color: iconColor ?? Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    title ?? _getTitle(currentIndex),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            _buildDrawerButton(context),
          ],
        ),
      );
    });
  }

  Widget _buildDrawerButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => DrawerPage());
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          'assets/icons/drawer_icon.png',
          width: 24,
          height: 24,
          color: iconColor,
        ),
      ),
    );
  }
}
