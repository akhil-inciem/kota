import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/base.dart';
import 'package:kota/views/home/home_screen.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/login/widgets/custom_textfield.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GuestRegistrationScreen extends StatefulWidget {
  const GuestRegistrationScreen({super.key});

  @override
  State<GuestRegistrationScreen> createState() =>
      _GuestRegistrationScreenState();
}

class _GuestRegistrationScreenState extends State<GuestRegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
               gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF015FC9), Color(0xFF7001C5)],
              ),
            ),
          ),

          SlideTransition(
            position: _animation,
            child: Stack(
              children: [
                // Centered SVG and Text
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 55.h,
                    ), // <-- Important padding!
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/splash_screen.svg',
                          width: 50.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Kerala Occupational\nTherapists Association',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 65.h, // control how much space it takes
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelledTextField(
                            label: 'Full Name',
                            hintText: 'Enter your full name',
                            icon: Icons.person,
                          ),
                          SizedBox(height: 2.h),
                          LabelledTextField(
                            label: 'User ID/ Name',
                            hintText: 'Guest ID will generate here',
                            isPassword: true,
                          ),
                          SizedBox(height: 2.h),
                          LabelledTextField(
                            label: 'Password',
                            hintText: 'Enter your password',
                            isPassword: true,
                          ),
                          SizedBox(height: 2.h),
                          LabelledTextField(
                            label: 'Re-Enter Password',
                            hintText: 'Re-Enter your password',
                            isPassword: true,
                          ),
                          SizedBox(height: 5.h),
                          CustomButton(
                            text: 'Sign In as a Guest',
                            backgroundColor: AppColors.primaryButton,
                            textColor: Colors.white,
                            isGuestButton: false,
                            onPressed: () {
                              authController.loginAsGuest();
                  Get.offAll(BaseScreen());
                              // Guest sign in logic
                            },
                          ),
                          SizedBox(height: 2.h),
                          // The Sign In clickable text remains same
                          Align(
                            alignment: Alignment.center,
                            child: Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.offAll(LoginScreen());
                                            print('Sign In clicked');
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
