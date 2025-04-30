import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF015FC9), 
              Color(0xFF7001C5),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG Image
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
                  // fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
