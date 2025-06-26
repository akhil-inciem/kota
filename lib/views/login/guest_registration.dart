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
  final _formKey = GlobalKey<FormState>();

  final AuthController authController = Get.put(AuthController());
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
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

          SlideTransition(
            position: _animation,
            child: Stack(
              children: [
                // Top Centered Logo and Text
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 60.h),
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
                    height: 72.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelledTextField(
                              controller: fullNameController,
                              label: 'Full Name',
                              hintText: 'Enter your full name',
                              icon: Icons.person,
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            LabelledTextField(
                              controller: emailController,
                              label: 'Email',
                              hintText: 'Enter your email',
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                } else if (!GetUtils.isEmail(value.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            LabelledTextField(
                              controller: phoneController,
                              label: 'Phone Number',
                              hintText: 'Enter your phone number',
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Phone number is required';
                                } else if (!GetUtils.isPhoneNumber(value.trim())) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            LabelledTextField(
                              controller: passwordController,
                              label: 'Password',
                              hintText: 'Enter your password',
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Password is required';
                                } else if (value.trim().length < 6) {
                                  return 'Minimum 6 characters required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            LabelledTextField(
                              controller: confirmPasswordController,
                              label: 'Re-Enter Password',
                              hintText: 'Re-Enter your password',
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please confirm your password';
                                } else if (value != passwordController.text.trim()) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 5.h),
                            CustomButton(
                              text: 'Sign In as a Guest',
                              backgroundColor: AppColors.primaryColor,
                              textColor: Colors.white,
                              isGuestButton: false,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await authController.registerAsGuest(
                                    fullName: fullNameController.text.trim(),
                                    mailId: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    confirmPassword: confirmPasswordController.text.trim(),
                                    phoneNumber: phoneController.text.trim(),
                                  );
                                  if (success) {
                                    Get.offAll(BaseScreen());
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 2.h),
                            Align(
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign In',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.offAll(LoginScreen());
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

