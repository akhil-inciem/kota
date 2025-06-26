import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/base.dart';
import 'package:kota/views/login/guest_registration.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/login/widgets/guest_member_dialogues.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _svgController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _moveUpAnimation;
  late AnimationController _containerController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _kotaMoveUpOnContainerSlideAnimation;
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _svgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _svgController, curve: Curves.easeIn));

    _moveUpAnimation = Tween<double>(
      begin: 0,
      end: -20.h,
    ).animate(CurvedAnimation(parent: _svgController, curve: Curves.easeOut));

    _containerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _containerController, curve: Curves.easeOut),
    );

    _kotaMoveUpOnContainerSlideAnimation = Tween<double>(
      begin: 0,
      end: -25.h,
    ).animate(
      CurvedAnimation(parent: _containerController, curve: Curves.easeOut),
    );

    _svgController.forward();

    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        _containerController.forward();
      }
    });
  }

  @override
  void dispose() {
    _svgController.dispose();
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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

          // Animated Positioned SVG + Text
          AnimatedBuilder(
            animation: Listenable.merge([_svgController, _containerController]),
            builder: (context, child) {
              double totalMoveUp =
                  _moveUpAnimation.value +
                  _kotaMoveUpOnContainerSlideAnimation.value;

              return Positioned(
                top:
                    (MediaQuery.of(context).size.height / 2 + 15.h) +
                    totalMoveUp,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
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
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Login Container Sliding In
          SlideTransition(position: _slideAnimation, child: _loginContainer()),
        ],
      ),
    );
  }

  Widget _loginContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50.h, // control how much space it takes
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelledTextField(
                  controller: emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value.trim()))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: 3.h),
                LabelledTextField(
                  controller: passwordController,
                  label: 'Password',
                  rightLabel: 'Forgot Password?',
                  onRightLabelTap: () {
                    Get.dialog(const GuestMemberDialog());
                  },
                  hintText: 'Enter password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                CustomButton(
                  text: 'I Am A Guest User',
                  backgroundColor: Colors.white,
                  textColor: AppColors.primaryColor,
                  onPressed: () => Get.offAll(GuestRegistrationScreen()),
                  isGuestButton: true,
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => CustomButton(
                    text:
                        authController.isLoading.value
                            ? 'Signing In...'
                            : 'Sign In',
                    backgroundColor: AppColors.primaryColor,
                    textColor: Colors.white,
                    isGuestButton: false,
                    isEnabled: !authController.isLoading.value,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        String email = emailController.text.trim();
                        String password = passwordController.text;

                        bool success = await authController.loginAsUser(
                          email,
                          password,
                        );
                        if (success) {
                          Get.offAll(BaseScreen());
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: 'Register Here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      'https://kbaiota.org/index/memberSignUp';
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication,);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
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
    );
  }

  
}
