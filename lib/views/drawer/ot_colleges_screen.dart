import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/model/colleges_model.dart';
import 'package:kota/views/drawer/widgets/college_tab_bar.dart';
import 'package:kota/views/home/widgets/home_tab_bar.dart';
import 'package:kota/views/widgets/search_bar.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class CollegesScreen extends StatefulWidget {
  @override
  _CollegesScreenState createState() => _CollegesScreenState();
}

class _CollegesScreenState extends State<CollegesScreen> {
  final SideMenuController controller = Get.find<SideMenuController>();
  int selectedIndex = 0;

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    controller.clearSearch(index == 0); // clear search and reset list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: _buildAppBar(),
            ),
            CustomSearchBar(
              controller: controller.searchController,
              onChanged: (query) {
                controller.filterColleges(selectedIndex == 0);
              },
            ),
            CollegeTabBar(
              selectedIndex: selectedIndex,
              onTabSelected: onTabSelected,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return selectedIndex == 0
                    ? _buildCollegeList(controller.keralaColleges)
                    : _buildCollegeList(controller.nonKeralaColleges);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'assets/icons/backbutton.png',
            color: Colors.black,
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "OT Colleges",
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildCollegeList(List<OtCollegesKerala> colleges) {
    if (colleges.isEmpty) {
      return Center(
        child: Text("No data available.", style: TextStyle(fontSize: 16.sp)),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: colleges.length,
      separatorBuilder: (_, __) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final college = colleges[index];
        final fullDetails = _buildFullDetailsText(college, index);

        return Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 36), // Leave space for icon
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ${college.collegeName}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      _buildInfoRow(Icons.school, college.university),
                      SizedBox(height: 1.h),
                      _buildInfoRow(Icons.person, college.principal),
                      SizedBox(height: 1.h),
                      _buildInfoRow(Icons.location_on, college.address),
                      SizedBox(height: 1.h),
                      _buildInfoRow(
                        Icons.location_city,
                        "${college.city}, ${college.state}",
                      ),
                      SizedBox(height: 1.h),
                      _buildInfoRow(Icons.book, _buildCoursesText(college)),
                      SizedBox(height: 1.h),
                      _buildInfoRow(
                        Icons.verified,
                        _buildAccreditationText(college),
                        iconColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(Icons.copy, size: 20.sp),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: fullDetails));
                      Get.snackbar(
                        "Copied",
                        "College details copied to clipboard",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _buildFullDetailsText(OtCollegesKerala college, int index) {
    return '''
${index + 1}. ${college.collegeName}
University: ${college.university}
Principal: ${college.principal}
Address: ${college.address}
City/State: ${college.city}, ${college.state}
${_buildCoursesText(college)}
${_buildAccreditationText(college)}
''';
  }

  Widget _buildInfoRow(
    IconData icon,
    String text, {
    Color iconColor = Colors.black,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17.sp, color: iconColor),
        SizedBox(width: 2.w),
        Expanded(child: Text(text, style: TextStyle(fontSize: 15.sp))),
      ],
    );
  }

  String _buildAccreditationText(OtCollegesKerala college) {
    return college.accredited.trim() == "1"
        ? "Accreditation: Accredited"
        : "Accreditation: Not Accredited";
  }

  String _buildCoursesText(OtCollegesKerala college) {
    List<String> courses = [];
    if (college.ugCourses.trim() == "1") courses.add("UG");
    if (college.pgCourses.trim() == "1") courses.add("PG");
    return "Courses: ${courses.isEmpty ? 'N/A' : courses.join(', ')}";
  }
}
