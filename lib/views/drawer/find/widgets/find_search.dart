import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchHeader extends StatefulWidget {
  final VoidCallback onReset;
  final ValueChanged<String> onSearch;
  final String hintText;

  const SearchHeader({
    Key? key,
    required this.onReset,
    required this.onSearch,
    this.hintText = 'Search Therapist..',
  }) : super(key: key);

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  final TextEditingController _controller = TextEditingController();

  void _clearSearch() {
    _controller.clear();
    widget.onSearch('');
    setState(() {}); // Refresh to hide suffix icon
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Back Button
        GestureDetector(
          onTap: widget.onReset,
          child: Container(
            width: 12.w,
            height: 6.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent),
            ),
            child: const Center(
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),
        // Search Field
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 1.w),
            child: TextField(
              autofocus: false,
              controller: _controller,
              onChanged: (value) {
                widget.onSearch(value);
                setState(() {}); // Show/hide clear button
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: _clearSearch,
                        child: const Icon(Icons.close),
                      )
                    : null,
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
            ),
          ),
        ),
      ],
    );
  }
}
