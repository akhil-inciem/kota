import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/forum/widgets/add_imageSection.dart';
import 'package:kota/views/forum/widgets/new_discussion_shimmer.dart';
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
        body: Column(
          children: [
            TopBar(
              title: "Discussion",
              leadingIconWidget: Icon(
                Icons.close,
                color: AppColors.primaryButton,
                size: 22.sp,
              ),
              onTap: () => Get.back(),
            ),
            SizedBox(height: 2.h),

            Expanded(
              child: Obx(() {
                if (userController.isLoading.value) {
                  return const NewDiscussionShimmer();
                } else if (userController.user.value == null) {
                  return const Center(child: Text('No user data found'));
                } else {
                  final user = userController.user.value!;
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: 2.h,
                    ), // prevent content from getting cut off
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Avatar + Name
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[300],
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          user.photo?.isNotEmpty == true
                                              ? user.photo!
                                              : 'https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName}&background=random&color=fff',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                      placeholder:
                                          (context, url) =>
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                      errorWidget:
                                          (context, url, error) => const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  '${user.firstName} ${user.lastName ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),

                          /// Title
                          _buildFieldLabel("Title *"),
                          _buildTextField(
                            controller: _forumController.titleController,
                            hint: "Enter title",
                            maxLines: 2,
                          ),

                          SizedBox(height: 2.h),

                          /// Description
                          _buildFieldLabel("Description *"),
                          _buildTextField(
                            controller: _forumController.descriptionController,
                            hint: "Type your question/queries here...",
                            maxLines: 8,
                          ),

                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ),

            /// Divider and Button Area – sticks to bottom
            Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
            AddImageSection(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              child: Obx(() {
                return CustomButton(
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: RichText(
        text: TextSpan(
          text: text.split(" *")[0],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          children: [
            if (text.contains("*"))
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: TextFormField(
        controller: controller,
        inputFormatters: [CapitalizeFirstLetterFormatter()],
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 16),
          border: InputBorder.none,
        ),
        validator:
            (value) =>
                (value == null || value.trim().isEmpty)
                    ? 'This field is required'
                    : null,
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
