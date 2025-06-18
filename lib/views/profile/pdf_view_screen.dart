import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String? title;

  const PDFViewerScreen({super.key, required this.pdfUrl, this.title});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool isDownloading = false;
  final SideMenuController sideMenuController = Get.find<SideMenuController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Column(
          children: [
            // Top bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              color: AppColors.primaryBackground,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      widget.title ?? 'PDF Document',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        isDownloading
                            ? null
                            : () async {
                              setState(
                                () => isDownloading = true,
                              ); // Show loader

                              try {
                                final downloader = MediaDownload();

                                // Get app's download directory
                                final directory =
                                    await getApplicationDocumentsDirectory();
                                final fileName =
                                    'downloaded_file_${DateTime.now().millisecondsSinceEpoch}.pdf';
                                final filePath = '${directory.path}/$fileName';

                                // Perform download
                                await downloader.downloadMedia(
                                  context,
                                  widget.pdfUrl,
                                );

                                final downloadedFile = File(filePath);
                                if (await downloadedFile.exists()) {
                                  CustomSnackbars.success(
                                    'Saved to ${downloadedFile.path}',
                                    'Download successful!',
                                  );
                                } else {
                                  CustomSnackbars.success(
                                    'Download requested. Please check your downloads folder.',
                                    'Success',
                                  );
                                }
                              } catch (e) {
                                CustomSnackbars.failure(
                                  'Download failed',
                                  'Error',
                                );
                              } finally {
                                setState(
                                  () => isDownloading = false,
                                ); // Reset loader
                              }
                            },
                    icon:
                        isDownloading
                            ? SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                            : Icon(
                              Icons.download_rounded,
                              color: Colors.black,
                              size: 6.w,
                            ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // PDF viewer filling the rest
            Container(
              height: 67.h,
              color: Colors.red,
              child: SfPdfViewer.network(
                widget.pdfUrl,
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                canShowScrollHead: false,
                canShowScrollStatus: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
