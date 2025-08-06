import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kota/views/profile/pdf_view_screen.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AiotaCertificateWidget extends StatefulWidget {
  final String imagePath;

  const AiotaCertificateWidget({Key? key, required this.imagePath})
    : super(key: key);

  @override
  State<AiotaCertificateWidget> createState() => _AiotaCertificateWidgetState();
}

class _AiotaCertificateWidgetState extends State<AiotaCertificateWidget> {
  bool isDownloading = false;

  bool _isPdf(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  void _openPdfViewer() {
    Get.to(() => PDFViewerScreen(pdfUrl: widget.imagePath));
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> downloadImage(String url) async {
    try {
      await requestStoragePermission(); // Request permission

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Use app's external storage directory
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory(); // App-specific dir
        } else {
          directory = await getApplicationDocumentsDirectory(); // For iOS
        }

        if (directory == null)
          throw Exception("Cannot access storage directory");

        final fileName =
            'certificate_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Downloaded to: $filePath');
        CustomSnackbars.success(
          'Image downloaded successfully!',
          'Saved to app folder',
        );
      } else {
        CustomSnackbars.failure('Failed to download image.', 'HTTP error');
      }
    } catch (e) {
      print('--------- $e');
      CustomSnackbars.failure('An error occurred.', 'Download failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = _isPdf(widget.imagePath);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:   [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/cerifications.png',
                      height: 2.5.h,
                      width: 2.5.h,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'AIOTA Certificate',
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ],
                ),
                isPdf
                    ? IconButton(
                      icon: Icon(Icons.remove_red_eye, size: 20.sp),
                      onPressed: _openPdfViewer,
                    )
                    : IconButton(
                      icon:
                          isDownloading
                              ? SizedBox(
                                width: 16.sp,
                                height: 16.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(Icons.download_rounded, size: 20.sp),
                      onPressed:
                          isDownloading
                              ? null
                              : () => downloadImage(widget.imagePath),
                    ),
              ],
            ),
            SizedBox(height: 1.h),

            // Viewer
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200]),
              clipBehavior: Clip.antiAlias,
              child:
                  isPdf
                      ? SfPdfViewer.network(
                        widget.imagePath,
                        canShowScrollHead: true,
                        canShowScrollStatus: true,
                      )
                      : Image.network(
                        widget.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Center(
                              child: Icon(Icons.broken_image, size: 30.sp),
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
