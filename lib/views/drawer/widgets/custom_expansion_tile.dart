import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<String> options;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:6.sp,vertical: 8.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            textColor: Colors.black,
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),
            ),
            children: options
                .map(
                  (option) => ListTile(
                    title: Text(option),
                    onTap: () {
                      // handle option click if needed
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
