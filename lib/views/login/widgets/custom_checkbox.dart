import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox({Key? key, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 30, // width of the checkbox
        height: 30, // height of the checkbox
       decoration: BoxDecoration(
          color: value ? Colors.blue : Colors.transparent, // Background color when checked
          border: Border.all(
            color: Colors.grey, // Grey border color
            width: 1.5, // Border width (thin border)
          ),
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
        ),
        child: value
            ? Icon(
                Icons.check,
                color: Colors.white, // Checkmark color
                size: 20, // Checkmark size
              )
            : null, // No checkmark when not selected
      ),
    );
  }
}
