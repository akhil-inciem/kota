import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/drawer/drawer_screen.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:kota/views/profile/widgets/certifcation_widget.dart';
import 'package:kota/views/profile/widgets/profile_change_password.dart';
import 'package:kota/views/profile/widgets/profile_header.dart';
import 'package:kota/views/profile/widgets/profile_info_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int certificationCount = 1;
  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    userController.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Obx(() {
          if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (userController.user.value == null) {
          return const Center(child: Text('No user data found'));
        } else {
          final user = userController.user.value!;
            return Column(
              children: [
                 ProfileHeader(user: user,),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         ProfileInfoWidget(
                          email: user.email!,
                          phoneNumber: user.primaryNumber!,
                          role: user.birthDate!,
                        ),
                        SizedBox(height: 2.h),
                        const ChangePasswordWidget(),
                        SizedBox(height: 2.h),
                        MyCertificationsWidget(
                          certificationCount: certificationCount,
                          imagePath: 'assets/images/certificate.jpg',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
        }
          }
        ),
      ),
    );
  }
}