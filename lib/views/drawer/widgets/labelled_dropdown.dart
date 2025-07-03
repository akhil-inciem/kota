import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LabelledDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedValue;
  final void Function(T?) onChanged;
  final String hintText;
  final String Function(T) itemAsString;

  const LabelledDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    required this.itemAsString,
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.labelText)),
        SizedBox(height: 8),
        Container(
  decoration: BoxDecoration(
    color: AppColors.primaryBackground, // Background color
    borderRadius: BorderRadius.circular(10), // 🎯 Rounded corners here
  ),
  child: DropdownButtonFormField<T>(
    value: effectiveValue,
    items: items.map((val) {
      final label = itemAsString(val);
      return DropdownMenuItem<T>(
        value: val,
        child: Tooltip(
          message: label,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      );
    }).toList(),
    onChanged: onChanged,
    isExpanded: true,
    decoration: const InputDecoration(
      hintText: "Select",
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.transparent, // So it doesn’t override container color
    ),
  ),
)


      ],
    );
  }
}
