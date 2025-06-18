import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<ExpansionOption> options;
  final bool isExpanded;
  final VoidCallback onExpansionChanged;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.options,
    required this.isExpanded,
    required this.onExpansionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: GestureDetector(
        onTap: onExpansionChanged,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ],
              ),
              if (isExpanded)
                ...options.map((option) => Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.heading,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            option.description,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
class ExpansionOption {
  final String heading;
  final String description;

  ExpansionOption({
    required this.heading,
    required this.description,
  });
}
