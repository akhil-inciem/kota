import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/updates_api_services.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/events/event_screen.dart';
import 'package:kota/views/favourites/favourite_screen.dart';
import 'package:kota/views/forum/discussions/forum_screen.dart';
import 'package:kota/views/home/home_screen.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/widgets/custom_bottom_nav_bar.dart';
import 'package:kota/views/updates/updates_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaseScreen extends StatefulWidget {
  int? index;
  BaseScreen({Key? key, this.index}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final HomeController homeController = Get.put(HomeController());
  final AuthController authController = Get.put(AuthController());
  final FavouriteController favController = Get.put(FavouriteController());
  final ForumController forumController = Get.put(ForumController());
  final EventController eventController = Get.put(EventController());
  final UpdateController updateController = Get.put(UpdateController());
  final SideMenuController sideMenuController = Get.put(SideMenuController());
  final List<Widget> _pages = [
    HomeScreen(),
    EventScreen(),
    ForumScreen(),
    FavouriteScreen(),
    UpdatesScreen(),
  ];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        homeController.index.value = widget.index!;
        _pageController.jumpToPage(widget.index!);
      }
    });

    ever(homeController.index, (index) {
      _pageController.jumpToPage(index);
    });

    ever(updateController.memberModel, (_) async {
      if (updateController.isMembershipExpired) {
        await Get.delete<UserController>();
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        bool shouldExit = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 4.h,
              ),
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Exit App",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Are you sure you want to exit the app?",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: CustomButton(
                            text: 'Exit',
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );

        if (shouldExit) {
          SystemNavigator.pop(); // Exits the app
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.primaryBackground,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              homeController.index.value = index;
              homeController.searchController.clear();
              forumController.resetFields();
              favController.resetFilters();
              eventController.searchController.clear();
              Get.find<UpdateController>().clearSearch();
            },
            children: List.generate(_pages.length, (index) {
              return _pages[index];
            }),
          ),
          bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
              currentIndex: homeController.index.value,
              onTap: (index) {
                homeController.index.value = index;
                _pageController.jumpToPage(index);
              },
              newUpdatesCount: updateController
                  .newItemsCount.value, // 👈 pass the reactive value
            ),
          ),
        ),
      ),
    );
  }
}
