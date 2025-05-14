import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:kota/views/events/event_screen.dart';
import 'package:kota/views/favourites/favourite_screen.dart';
import 'package:kota/views/forum/forum_screen.dart';
import 'package:kota/views/home/home_screen.dart';
import 'package:kota/views/home/widgets/custom_bottom_nav_bar.dart';
import 'package:kota/views/updates/updates_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final HomeController homeController = Get.find<HomeController>();

  final List<Widget> _pages = [
    HomeScreen(),  
    EventScreen(), 
    ForumScreen(),
    FavouriteScreen(),
    UpdatesScreen(),
  ];
 
  // Create a PageController to control the PageView
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Listen to changes in the index and move the page controller accordingly
    ever(homeController.index, (index) {
      _pageController.jumpToPage(index); // Manually change page when index changes
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primaryBackground,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          homeController.index.value = index;
          homeController.searchController.clear();
          Get.find<UpdateController>().clearSearch();

        },
        children: List.generate(_pages.length, (index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double page = _pageController.page ?? 0.0;
              double opacity = (1 - (page - index).abs()).clamp(0.0, 1.0);

              double scale = (1 - (page - index).abs() * 0.2).clamp(0.8, 1.0);
              return Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: _pages[index],
          );
        }),
      ),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
        currentIndex: homeController.index.value,
        onTap: (index) {
          // Update the index when bottom navigation is tapped
          homeController.index.value = index;
        _pageController.jumpToPage(index);
        },
      )),
    );
  }
}