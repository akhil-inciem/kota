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
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        children: [
          // Expanded TextField
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search here',
                prefixIcon: const Icon(Icons.search),
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

