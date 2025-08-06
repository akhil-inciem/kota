
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class KotaCertificateWidget extends StatefulWidget {
  final String name;
  final String issuedOn;
  final String validTill;
  final String userPhotoPath;

  const KotaCertificateWidget({
    Key? key,
    required this.name,
    required this.issuedOn,
    required this.validTill,
    required this.userPhotoPath,
  }) : super(key: key);

  @override
  State<KotaCertificateWidget> createState() =>
      _KotaCertificateWidgetState();
}

class _KotaCertificateWidgetState extends State<KotaCertificateWidget> {
  final GlobalKey _certificateKey = GlobalKey();

  Future<void> _downloadCertificate() async {
    try {
      // Request permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        Fluttertoast.showToast(msg: "Storage permission denied");
        return;
      }

      RenderRepaintBoundary boundary = _certificateKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        name: "certificate_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        Fluttertoast.showToast(msg: "Certificate saved to gallery");
      } else {
        Fluttertoast.showToast(msg: "Failed to save certificate");
      }
    } catch (e) {
      print("Error saving certificate: $e");
      Fluttertoast.showToast(msg: "Error saving certificate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Align(alignment: Alignment.centerLeft,child: Text("KOTA Cerificate")),
        ),
        SizedBox(height: 1.h,),
        RepaintBoundary(
          key: _certificateKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Background Certificate Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/KOTA_certificate.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // User Photo - Top Right Corner
                  Positioned(
                    top: 43.h,
                    right: 37.w,
                    child: ClipOval(
                      child: Image.network(
                        widget.userPhotoPath,
                        width: 14.w,
                        height: 14.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Name Overlay
                  Positioned(
                    top: 25.h,
                    left: 25.w,
                    right: 25.w,
                    child: Center(
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // Issued On & Valid Till
                  Positioned(
                    bottom: 14.5.h,
                    left: 26.w,
                    child: Text(
                      widget.issuedOn,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    ),
                  ),
                  Positioned(
                    bottom: 14.5.h,
                    right: 11.w,
                    child: Text(
                      widget.validTill,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 0.5.h),

        // Download Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _downloadCertificate,
                icon: Icon(Icons.download, color: Colors.black, size: 2.2.h),
                label: Text(
                  "Download Certificate",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }
}
