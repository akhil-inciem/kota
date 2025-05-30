import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String? title;

  const PDFViewerScreen({
    Key? key,
    required this.pdfUrl,
    this.title,
  }) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

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
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 6.w),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      widget.title ?? 'PDF Document',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Obx(() {
                    return IconButton(
                      onPressed: sideMenuController.isDownloading.value
                          ? null
                          : () => sideMenuController.downloadPdf(widget.pdfUrl),
                      icon: sideMenuController.isDownloading.value
                          ? SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.download_rounded, color: Colors.black, size: 6.w),
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 10.h,),

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
