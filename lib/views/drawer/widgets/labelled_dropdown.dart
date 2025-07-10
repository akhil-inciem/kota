import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

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
    final effectiveValue = selectedValue ?? (items.isNotEmpty ? items.first : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.labelText)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField2<T>(
  value: effectiveValue,
  items: items.map((val) {
    final label = itemAsString(val);
    return DropdownMenuItem<T>(
      value: val,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }).toList(),
  onChanged: onChanged,
  isExpanded: true,
  decoration: const InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 16), // 👈 match this
    border: InputBorder.none,
    hintText: 'Select',
  ),
  dropdownStyleData: DropdownStyleData(
    padding: const EdgeInsets.symmetric(horizontal: 0), // Sheet padding
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
  ),
)

        ),
      ],
    );
  }
}
