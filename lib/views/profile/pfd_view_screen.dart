import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PDFViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          
          children: [
            _buildAppBar(), 
            Expanded(child: SfPdfViewer.network(pdfUrl)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, size: 3.h),
        ),
        SizedBox(width: 4.w),
        Text(
          "Contact Us",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
