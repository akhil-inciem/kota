import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/forum/widgets/add_imageSection.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewDiscussionPage extends StatefulWidget {
  const NewDiscussionPage({super.key});

  @override
  State<NewDiscussionPage> createState() => _NewDiscussionPageState();
}

class _NewDiscussionPageState extends State<NewDiscussionPage> {
  final ForumController _forumController = Get.find<ForumController>();

  final userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    userController.loadUserProfile();
    _forumController.titleController.addListener(() {
      final text = _forumController.titleController.text;
      final capitalized = capitalizeFirstLetter(text);
      if (text != capitalized) {
        final selection = _forumController.titleController.selection;
        _forumController.titleController.value = TextEditingValue(
          text: capitalized,
          selection: selection,
        );
      }
    });
    _forumController.descriptionController.addListener(() {
      final text = _forumController.descriptionController.text;
      final capitalized = capitalizeFirstLetter(text);
      if (text != capitalized) {
        final selection = _forumController.descriptionController.selection;
        _forumController.descriptionController.value = TextEditingValue(
          text: capitalized,
          selection: selection,
        );
      }
    });
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (userController.user.value == null) {
            return const Center(child: Text('No user data found'));
          } else {
            final user = userController.user.value!;
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TopBar(
                        title: "New Discussion",
                        leadingIconWidget: Icon(Icons.close, color: AppColors.primaryButton,size: 24.sp,),
                        onTap: () => Get.back(),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              user.photo?.isNotEmpty == true
                                  ? user.photo!
                                  : 'https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName}&background=random&color=fff',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '${user.firstName} ${user.lastName ?? ''}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    /// Title TextField
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Title ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: _forumController.titleController,
                            inputFormatters: [CapitalizeFirstLetterFormatter()],
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Enter title',
                              hintStyle: TextStyle(fontSize: 16),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Title is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Description field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Description ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: _forumController.descriptionController,
                            inputFormatters: [CapitalizeFirstLetterFormatter()],
                            maxLines: 8,
                            decoration: InputDecoration(
                              hintText: 'Type your question/queries here...',
                              hintStyle: TextStyle(fontSize: 16),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Description is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                    SizedBox(height: 2.h),
                    AddImageSection(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CustomButton(
                        isEnabled: !_forumController.isLoading.value,
                        text:
                            _forumController.isLoading.value
                                ? "Posting..."
                                : "Create Discussion",
                        backgroundColor: AppColors.primaryButton,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _forumController.createDiscussion();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final capitalized = text[0].toUpperCase() + text.substring(1);
    if (text == capitalized) return newValue;

    return TextEditingValue(
      text: capitalized,
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
