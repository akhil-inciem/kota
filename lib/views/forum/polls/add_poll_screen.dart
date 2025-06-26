import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../model/poll_model.dart';

class NewPollPage extends StatefulWidget {
  final PollData? pollToEdit; // If null => create mode

  const NewPollPage({super.key, this.pollToEdit});

  @override
  State<NewPollPage> createState() => _NewPollPageState();
}

class _NewPollPageState extends State<NewPollPage> {
  final ForumController _forumController = Get.find<ForumController>();
  final _formKey = GlobalKey<FormState>();
  final optionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.pollToEdit != null) {
      // Prefill for edit mode
      _forumController.pollTitleController.text =
          widget.pollToEdit!.title ?? '';

       final expiryDateStr = widget.pollToEdit!.expairydate;
    if (expiryDateStr != null ) {
      final parsedDate = DateTime.tryParse(expiryDateStr.toString());
      if (parsedDate != null) {
        _forumController.pollExpiryDate.value = parsedDate;
      }
    }

      final options = _parseOptions(widget.pollToEdit!.pollFeild ?? '');
      _forumController.pollFields.clear();
      _forumController.pollFields.addAll(
        options.map((opt) => TextEditingController(text: opt)).toList(),
      );

      final allowMultiple =
          widget.pollToEdit!.allowmultiple?.toLowerCase() == 'true';
      _forumController.allowMultipleSwitchController.value = allowMultiple;
    } else {
      // Fresh state for new poll
      _forumController.pollExpiryDate.value = null;
      _forumController.pollTitleController.clear();
      _forumController.pollFields.clear();
      _forumController.allowMultipleSwitchController.value = false;
    }
  }

  Future<void> _pickExpiryDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365)), // e.g., next 1 year
  );
  if (picked != null) {
    _forumController.pollExpiryDate.value = picked;
  }
}


  @override
  void dispose() {
    optionController.dispose();
    for (var ctrl in _forumController.pollFields) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Custom Top Bar to match screenshot
            TopBar(
              title: widget.pollToEdit == null ? "New Poll" : "Edit Poll",
              leadingIconWidget: Icon(
                Icons.close,
                color: AppColors.primaryColor,
                size: 22.sp,
              ),
              onTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),

                      /// Poll Question
                      Text(
                        "Question",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _forumController.pollTitleController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Ask question",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16.sp,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator:
                              (value) =>
                                  (value == null || value.trim().isEmpty)
                                      ? 'This field is required'
                                      : null,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      /// Poll Options
                      Text(
                        "Options",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      // Options Container
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Add new option field
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: optionController,
                                    decoration: InputDecoration(
                                      hintText: 'Add Option',
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 16.sp,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onSaved: (_) => _addOption(),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _addOption,
                                  child: Icon(
                                    Icons.add_circle,
                                    color: AppColors.primaryColor,
                                    size: 22.sp,
                                  ),
                                ),
                              ],
                            ),
                            // Display added options
                            Obx(() {
                              final reversedOptions =
                                  _forumController.pollFields
                                      .asMap()
                                      .entries
                                      .toList()
                                      .reversed
                                      .toList();
                              return Column(
                                children: List.generate(reversedOptions.length, (
                                  i,
                                ) {
                                  final entry = reversedOptions[i];
                                  final index = entry.key;
                                  final option = entry.value;
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 2.h),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                option.text,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _forumController.pollFields
                                                    .removeAt(index);
                                                _forumController
                                                    .validateCreatePoll();
                                              },
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                                size: 22.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Add Divider only between items, not after last
                                      if (i != reversedOptions.length - 1)
                                        Divider(
                                          thickness: 1,
                                          height: 2.5.h,
                                          color: Colors.grey.shade300,
                                        ),
                                    ],
                                  );
                                }),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Poll Expiry Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pick Expiry Date',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Obx(() {
                            final selectedDate =
                                _forumController.pollExpiryDate.value;
                            return GestureDetector(
                              onTap: _pickExpiryDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  selectedDate != null
                                      ? DateFormat(
                                        'dd MMM yyyy',
                                      ).format(selectedDate)
                                      : 'Select Date',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 1.h,),
                      Obx(() {
  final selectedDate = _forumController.pollExpiryDate.value;
  final isDateValid = selectedDate != null;
  final showError = !isDateValid && _forumController.isCreatePollEnabled.value;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1.h),
      if (showError)
        Text(
          'Please select an expiry date',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.red,
          ),
        ),
    ],
  );
}),

                      SizedBox(height: 4.h),

                      /// Allow Multiple Selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Allow multiple answers',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          AdvancedSwitch(
                            controller:
                                _forumController.allowMultipleSwitchController,
                            activeColor: AppColors.primaryColor,
                            inactiveColor: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                            width: 60.0,
                            height: 30.0,
                            thumb: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Submit Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: Obx(() {
                return CustomButton(
                  isEnabled:
                      _forumController.isCreatePollEnabled.value &&
                      !_forumController.isLoading.value,
                  text:
                      _forumController.isLoading.value
                          ? "Posting..."
                          : "Create Poll",
                  backgroundColor: AppColors.primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.pollToEdit == null) {
                        await _forumController.submitPoll();
                        _forumController.loadPolls();
                      } else {
                        await _forumController.updatePoll(
                          widget.pollToEdit!.id ?? '',
                        );
                        _forumController.loadPolls();
                      }
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _parseOptions(String pollFeild) {
    try {
      final decoded = jsonDecode(pollFeild);
      if (decoded is List) {
        return decoded.map((e) => e.toString().trim()).toList();
      }
    } catch (e) {
      // fallback
    }
    return pollFeild.split(',').map((e) => e.trim()).toList();
  }

  void _addOption() {
    if (optionController.text.isNotEmpty) {
      final newController = TextEditingController(text: optionController.text);
      _forumController.pollFields.add(newController);
      optionController.clear();
      _forumController.validateCreatePoll();
    }
  }
}
