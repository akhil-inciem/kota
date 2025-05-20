import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyCertificationsWidget extends StatelessWidget {
  final int certificationCount;
  final String imagePath; // path to your image asset or network image

  const MyCertificationsWidget({
    Key? key,
    required this.certificationCount,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w), // outer padding
      child: Container(
        padding: EdgeInsets.all(2.h), // inner padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              children: [
                const Icon(Icons.badge),
                SizedBox(width: 5.w),
                Text('My Certifications ($certificationCount)'),
              ],
            ),
            SizedBox(height: 2.h),
            // Image
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
)
          ],
        ),
      ),
    );
  }
}
