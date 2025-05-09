import 'package:flutter/material.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchResultsWidget extends StatelessWidget {
  final bool isClinic;
  final List<Map<String, dynamic>> results;
  final VoidCallback onReset;

  const SearchResultsWidget({
    super.key,
    required this.isClinic,
    required this.results,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomButton(
              width: 50.w,
              text: "Reset",
              backgroundColor: Colors.grey[300]!,
              textColor: Colors.black,
              onPressed: onReset,
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: results.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                title: Text("${index + 1}. ${result['name']}"),
                subtitle: Text(
                    "District: ${result['district']} | Practice: ${result['practice']}"),
              );
            },
          ),
        ),
      ],
    );
  }
}
