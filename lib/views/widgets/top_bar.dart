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
  final bool isEvent;

  TopBar({
    this.title,
    this.onTap,
    this.iconColor,
    this.leadingIcon,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!showSearch)
                  Expanded(
                    child:
                        (currentIndex == 0 && widget.title == null)
                            ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SvgPicture.asset(
                                  'assets/images/KOTA_Logo.svg',
                                  width: 100,
                                ),
                              ),
                            )
                            : Row(
                              children: [
                                InkWell(
                                  onTap:
                                      widget.onTap ??
                                      () => homeController.index.value = 0,
                                  child: Image.asset(
                                    widget.leadingIcon ??
                                        'assets/icons/backbutton.png',
                                    width: 20,
                                    height: 24,
                                    color:
                                        widget.iconColor ??
                                        AppColors.primaryButton,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  widget.title ?? _getTitle(currentIndex),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                  ),
                Spacer(),
                // Search Icon
                if (widget.isEvent)
                  InkWell(
                    onTap: () {
                      setState(() {
                        showSearch = !showSearch;
                        if (!showSearch) searchController.clear();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Container(
                        padding: EdgeInsets.all(13.sp),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius:
                              showSearch
                                  ? BorderRadius.horizontal(
                                    right: Radius.circular(8),
                                    left: Radius.circular(0),
                                  )
                                  : BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          'assets/icons/search.png',
                          width: 20,
                          height: 17.sp,
                          color: widget.iconColor,
                        ),
                      ),
                    ),
                  ),
                if (currentIndex == 0 && authController.isGuest)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomButton(
                        text: "Register",
                        backgroundColor: AppColors.primaryButton,
                        textColor: Colors.white,
                        height: 5.h,
                        onPressed: () async {
                          const url =
                              'http://dev.kbaiota.org/index/memberSignUp';
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

            Positioned(
              right: 22.w, // Adjust for drawer and search icons
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: showSearch ? 67.w : 0,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: showSearch ? 1 : 0,
                  child: IgnorePointer(
                    ignoring: !showSearch,
                    child: SizedBox(
                      height: 5.h, // Reduced height
                      child: TextField(
                        controller: searchController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Search here',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(8), // Only left side
                              right: Radius.circular(0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(8),
                              right: Radius.circular(0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(8),
                              right: Radius.circular(0),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          isDense: true, // Ensures more compact height
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          'assets/icons/drawer_icon.png',
          width: 24,
          height: 24,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
