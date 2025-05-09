import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LabelledDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final String hintText;

  const LabelledDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveValue =
        (selectedValue != null && items.contains(selectedValue))
            ? selectedValue
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: 0.8.h),
        DropdownButtonFormField<String>(
          value: effectiveValue, // ensures hint shows when value is null
          items: items
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}

