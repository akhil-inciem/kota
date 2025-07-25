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
import 'package:url_launcher/url_launcher.dart';

class TopBar extends StatefulWidget {
  final String? title;
  final Function()? onTap;
  final Color? iconColor;
  final String? leadingIcon;
  final Widget? leadingIconWidget;
  final bool isEvent;

  TopBar({
    this.title,
    this.onTap,
    this.iconColor,
    this.leadingIcon,
    this.leadingIconWidget,
    this.isEvent = false,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final AuthController authController = Get.find<AuthController>();
  final HomeController homeController = Get.find<HomeController>();
  bool showSearch = false;
  final TextEditingController searchController = TextEditingController();

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Event Calendar';
      case 2:
        return 'Forum';
      case 3:
        return 'Favourites';
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
        padding:  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!showSearch)
                  Expanded(
                    child:
                        (currentIndex == 0 && widget.title == null)
                            ? Align(
                              alignment: Alignment.centerLeft,
                              child: SvgPicture.asset(
                                'assets/images/KOTA_Logo.svg',
                                width: 20.w,
                              ),
                            )
                            : Row(
                              children: [
                                InkWell(
                                  onTap:
                                      widget.onTap ??
                                      () => homeController.index.value = 0,
                                  child:
                                      widget.leadingIconWidget ??
                                      Image.asset(
                                        widget.leadingIcon ??
                                            'assets/icons/backbutton.png',
                                        width: 6.w,
                                        height: 2.5.h,
                                        color:
                                            widget.iconColor ??
                                            AppColors.primaryColor,
                                      ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    widget.title ?? _getTitle(currentIndex),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xFF0A2C49),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                  ),
                Spacer(),
                if (currentIndex == 0 && authController.isGuest)
                  Expanded(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 2.w),
                      child: CustomButton(
                        text: "Register",
                        backgroundColor: AppColors.primaryColor,
                        textColor: Colors.white,
                        height: 5.h,
                        onPressed: () async {
                          const url =
                              'https://kbaiota.org/index/memberSignUp';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                            // await launch(url, forceWebView: true, enableJavaScript: true);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                  ),
                _buildDrawerButton(),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDrawerButton() {
    return InkWell(
      onTap: () {
        Get.to(() => DrawerPage());
      },
      child: Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          'assets/icons/drawer_icon.png',
          width: 2.5.h,
          height: 2.5.h,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
