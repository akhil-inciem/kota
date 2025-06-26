import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/login/widgets/custom_checkbox.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTermsAccepted = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Register',
                        style: TextStyle(
                          color: AppColors.labelText,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ), // Replace with desired icon
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                color: AppColors.primaryBackground,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primaryText,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primaryText,
                      indicatorWeight: 4.0,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 2.w),
                      tabs: [Tab(text: 'Professional'), Tab(text: 'Student')],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildForm(isStudent: false),
                    _buildForm(isStudent: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm({required bool isStudent}) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isStudent)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: Colors.red.shade50, // Light red background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "IMPORTANT INFORMATION: This option is only for undergraduate students.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                ),
              ),
            ),
          LabelledTextField(
            label: 'Email',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
          SizedBox(height: 2.h),
          LabelledTextField(
            label: 'Mobile Number',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
          SizedBox(height: 2.h),
          LabelledTextField(
            label: 'First Name',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
          SizedBox(height: 2.h),
          LabelledTextField(
            label: 'Last Name',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LabelledTextField(
                  label: 'Gender',
                  hintText: 'Select Gender',
                  icon: Icons.person,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: LabelledTextField(
                  label: 'Date of Birth',
                  hintText: 'Select Date',
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LabelledTextField(
            label: 'Password',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
          SizedBox(height: 2.h),
          LabelledTextField(
            label: 'Re-Enter Password',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomCheckbox(
                value: _isTermsAccepted,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isTermsAccepted = newValue ?? false;
                  });
                },
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'I have read and agree to the KOTA ',
                    style: const TextStyle(fontSize: 10),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                print('Terms clicked');
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          CustomButton(
            text: "Register",
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
