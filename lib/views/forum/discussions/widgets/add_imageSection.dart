import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropping/image_cropping.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddImageSection extends StatefulWidget {
  const AddImageSection({super.key});

  @override
  State<AddImageSection> createState() => _AddImageSectionState();
}

class _AddImageSectionState extends State<AddImageSection> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  Future<void> pickAndCropSingleImage(BuildContext context) async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90, // Compress before crop
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        ImageCropping.cropImage(
          context: context,
          imageBytes: bytes,
          onImageDoneListener: (croppedBytes) async {
            if (croppedBytes == null) return;

            final file = await _saveBytesToFile(croppedBytes);
            final fileSizeInMB = await file.length() / (1024 * 1024);

            if (fileSizeInMB > 5) {
              CustomSnackbars.oops(
                'Please select images smaller than 5 MB',
                'Image too large',
              );
              return;
            }
            setState(() {
              _selectedImages.add(file);
            });
            // Optional: sync to controller as needed
            Get.find<ForumController>().addImage(XFile(file.path));
          },
        );
      }
    } catch (e, st) {
      print("Image pick/crop error: $e");
      print("Stacktrace: $st");
    }
  }

  Future<File> _saveBytesToFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await File(path).writeAsBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Image",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              GestureDetector(
                onTap: () => pickAndCropSingleImage(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 22.sp,
                    horizontal: 24.sp,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryBackground,
                  ),
                  child: Image.asset(
                    'assets/icons/camera.png',
                    height: 4.h,
                    width: 4.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(_selectedImages.length, (index) {
                      final image = _selectedImages[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 2.w, top: 1.h),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 11.h,
                              width: 13.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryBackground,
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -1.h,
                              right: -1.w,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                  // Optional: remove from controller
                                  Get.find<ForumController>().removeImage(index);
                                },
                                child: Container(
                                  height: 2.5.h,
                                  width: 2.5.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
// class _AddImageSectionState extends State<AddImageSection> {
//   final ImagePicker _picker = ImagePicker();
//   final List<File> _selectedImages = [];
//   Future<void> pickAndCropSingleImage(BuildContext context) async {
//     try {
//       await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 90, // Compress before crop
//       );
//       if (pickedFile != null) {
//         final bytes = await pickedFile.readAsBytes();
//         ImageCropping.cropImage(
//           context: context,
//           imageBytes: bytes,
//           onImageDoneListener: (croppedBytes) async {
//             if (croppedBytes == null) return;
//             final file = await _saveBytesToFile(croppedBytes);
//             final fileSizeInMB = await file.length() / (1024 * 1024);
//             if (fileSizeInMB > 5) {
//               // CustomSnackbars.oops(
//               //   'Please select images smaller than 5 MB',
//               //   'Image too large',
//               // );
//               return;
//             }
//             setState(() {
//               _selectedImages.add(file);
//             });
//             // Optional: sync to controller as needed
//            // Get.find<ForumController>().addImage(XFile(file.path));
//           },
//         );
//       }
//     } catch (e, st) {
//       print("Image pick/crop error: $e");
//       print("Stacktrace: $st");
//     }
//   }
//   Future<File> _saveBytesToFile(Uint8List bytes) async {
//     final tempDir = await getTemporaryDirectory();
//     final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//     return await File(path).writeAsBytes(bytes);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 6.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Add Image",
//             style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 2.h),
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () => pickAndCropSingleImage(context),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 22.sp,
//                     horizontal: 24.sp,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color:Colors.red
//                   ),
//                 ),
//               ),
//               SizedBox(width: 3.w),
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: List.generate(_selectedImages.length, (index) {
//                       final image = _selectedImages[index];
//                       return Padding(
//                         padding: EdgeInsets.only(right: 2.w, top: 1.h),
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             Container(
//                               height: 11.h,
//                               width: 13.h,
//                               decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(10),
//                                 color: Colors.red,
//                                 image: DecorationImage(
//                                   image: FileImage(image),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               top: -1.h,
//                               right: -1.w,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _selectedImages.removeAt(index);
//                                   });
//                                   // Optional: remove from controller
//                                  // Get.find<ForumController>().removeImage(index);
//                                 },
//                                 child: Container(
//                                   height: 2.5.h,
//                                   width: 2.5.h,
//                                  decoration: BoxDecoration(
//                                color: Colors.grey,
//                                    shape: BoxShape.circle,
//                                   ),
//                                   child: const Center(
//                                     child: Icon(
//                                      Icons.close,
//                                      color: Colors.white,
//                                      size: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 4.h),
//         ],
//       ),
//     );
//   }
// }