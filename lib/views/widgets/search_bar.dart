import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomSearchBar extends StatelessWidget {
  final bool filter;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomSearchBar({Key? key, this.filter = false,this.controller,this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          // Expanded TextField
          Expanded(
            child: TextField(
              autofocus: false,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search here',
                prefixIcon:Padding(
  padding:  EdgeInsets.all(1.5.h), // Adjust for better alignment
  child: SizedBox(
    height: 1.h,
    width: 1.h,
    child: Image.asset('assets/icons/search.png'),
  ),
),

                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
              ),
              onChanged: onChanged,
            ),
          ),

          // If filter is true, show a container
          if (filter) ...[
            
          ],
        ],
      ),
    );
  }
}

