import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:kota/apiServices/notification_services.dart';
import 'package:kota/views/profile/pfd_view_screen.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyCertificationsWidget extends StatelessWidget {
  final int certificationCount;
  final String imagePath; // PDF URL

   MyCertificationsWidget({
    Key? key,
    required this.certificationCount,
    required this.imagePath,
  }) : super(key: key);

  void _openPdfViewer(BuildContext context) {
    Get.to(() => PDFViewerScreen(pdfUrl: imagePath));
  }
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> downloadPdf(
  String url,
  String fileName,
  BuildContext context,
) async {
  try {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }

    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    final savePath = '${downloadsDir.path}/$fileName';

    final dio = Dio();

    // 🔔 Notify: download started
    // await NotificationService.showNotification('Download Started', fileName);

    final response = await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          debugPrint("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );

    if (response.statusCode == 200) {
      CustomSnackbars.success("Saved to Downloads", "Download Successful");

      // 🔔 Notify: download successful
      // await NotificationService.showNotification('Download Complete', fileName);
    } else {
      throw Exception('Download failed');
    }
  } catch (e) {
    CustomSnackbars.oops(e.toString(), "Download Failed");

    // 🔔 Notify: download failed
    // await NotificationService.showNotification('Download Failed', e.toString());
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.badge),
                    SizedBox(width: 2.w),
                    Text('My Certifications ($certificationCount)'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      tooltip: "View",
                      onPressed: () => _openPdfViewer(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: "Download",
                      onPressed: () {
                        downloadPdf(imagePath, 'my_certification.pdf', context);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Embedded Viewer
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200]),
              clipBehavior: Clip.antiAlias,
              child: SfPdfViewer.network(
                imagePath,
                canShowScrollHead: true,
                canShowScrollStatus: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
