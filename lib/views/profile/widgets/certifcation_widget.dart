import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:kota/views/profile/pfd_view_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyCertificationsWidget extends StatelessWidget {
  final int certificationCount;
  final String imagePath; // PDF URL

  const MyCertificationsWidget({
    Key? key,
    required this.certificationCount,
    required this.imagePath,
  }) : super(key: key);

  void _openPdfViewer(BuildContext context) {
    Get.to(() => PDFViewerScreen(pdfUrl: imagePath));
  }

  void _downloadPdf(BuildContext context) {
    FileDownloader.downloadFile(
      url: imagePath,
      name: "my_certificate.pdf",
      onDownloadCompleted: (path) {
        Get.snackbar("Download Complete", "Saved to: $path", snackPosition: SnackPosition.BOTTOM);
      },
      onDownloadError: (error) {
        Get.snackbar("Download Failed", error.toString(), snackPosition: SnackPosition.BOTTOM);
      },
    );
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
                      onPressed: () => _downloadPdf(context),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 2.h),

            // Embedded Viewer
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
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