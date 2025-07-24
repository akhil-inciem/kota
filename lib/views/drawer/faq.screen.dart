import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/views/home/widgets/list_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final SideMenuController controller = Get.find<SideMenuController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              _buildAppBar(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const FaqShimmer();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        "Frequently Asked Questions",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Color(0xFF0A2C49),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: controller.faqList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 1.h),
                          itemBuilder: (context, index) {
                            final faq = controller.faqList[index];

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                    ),
                                    child: Obx(
                                      () => ExpansionTile(
                                        key: Key(
                                          index ==
                                                  controller.expandedIndex.value
                                              ? 'expanded'
                                              : 'collapsed_$index',
                                        ),
                                        textColor: AppColors.primaryText,
                                        leading: const CircleAvatar(
                                          backgroundColor:
                                              AppColors.primaryText,
                                          child: Icon(
                                            Icons.question_mark,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          faq.question ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            color: Color(0xFF0A2C49),
                                          ),
                                        ),
                                        childrenPadding: EdgeInsets.symmetric(
                                          horizontal: 1.5.h,
                                          vertical: 1.h,
                                        ),
                                        trailing: Icon(
                                          index ==
                                                  controller.expandedIndex.value
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                        ),
                                        initiallyExpanded:
                                            index ==
                                            controller.expandedIndex.value,
                                        onExpansionChanged: (expanded) {
                                          controller.toggleExpansion(
                                            expanded ? index : -1,
                                          );
                                        },
                                        children: [
                                          Html(
                                            data: faq.answer ?? '',
                                            style: {
                                              "h4": Style(
                                                fontSize: FontSize(15.sp),
                                                fontWeight: FontWeight.normal,
                                              ),
                                              "*": Style(
                                                fontSize: FontSize(15.sp),
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                              ),
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
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
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "FAQ",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0A2C49),
          ),
        ),
      ],
    );
  }
}
