import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/profile_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IdCardWidget extends StatefulWidget {
  final User user;

  IdCardWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<IdCardWidget> createState() => _IdCardWidgetState();
}

class _IdCardWidgetState extends State<IdCardWidget> {
  final authController = Get.find<AuthController>();
  final GlobalKey _cardKey = GlobalKey();

  String _getFullName() {
    final firstName = widget.user.firstName ?? '';
    final lastName = widget.user.lastName ?? '';

    if (firstName.isEmpty && lastName.isEmpty) {
      return '';
    }

    return '$firstName $lastName'.trim();
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    child: Column(
      children: [
        RepaintBoundary(
          key: _cardKey,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: _buildCardContent(),
          ),
        ),
        SizedBox(height: 2.h),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _downloadCard,
            icon: Icon(Icons.download, color: Colors.black, size: 2.2.h),
            label: Text(
              "Download ID Card",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 2,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w), // slightly reduced padding inside
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabelValue(
                      label: 'MEMBERSHIP NO',
                      value: widget.user.aiotaMembershipNo ?? '',
                      valueFontSize: 13.sp,
                    ),
                    _buildLabelValue(
                      label: 'EMAIL ID',
                      value: widget.user.email ?? "",
                      valueFontSize: 13.sp,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side: Profile Picture with flex
                    Flexible(
                      flex: 2, // smaller flex than right side
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 30.w, // define width explicitly
                          height: 18.h, // define height explicitly
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.shade300,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child:
                              widget.user.photo != null
                                  ? Image.network(
                                    widget.user.photo!,
                                    fit: BoxFit.cover,
                                  )
                                  : Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w), // less horizontal space here
                    // Right Side: Member Details
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelValue(
                            label: 'NAME',
                            value: _getFullName(),
                            isBoldValue: true,
                            valueFontSize: 14.sp,
                          ),
                          SizedBox(height: 1.h),
                          _buildLabelValue(
                            label: 'ADDRESS',
                            value:
                                widget.user.address ??
                                'Bethel House, Asramam, Kollam, Kerala 691002 /n ',
                            valueFontSize: 13.sp,
                            maxLines: 3,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 20.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                image:
                                    widget.user.sign != null
                                        ? DecorationImage(
                                          image: NetworkImage(
                                            widget.user.sign!,
                                          ),
                                          fit: BoxFit.contain,
                                        )
                                        : null,
                              ),
                              child:
                                  widget.user.sign == null
                                      ? CustomPaint(painter: SignaturePainter())
                                      : null,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Center(
                            child: Text(
                              "SECRETARY, KOTA",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildLabelValue({
    required String label,
    required String value,
    bool isBoldValue = false,
    double labelFontSize = 11,
    double valueFontSize = 14,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: labelFontSize.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 0.2.h),
        Text(
          value,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: isBoldValue ? FontWeight.w700 : FontWeight.w500,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
      ],
    );
  }
  Future<void> _downloadCard() async {
    try {
      RenderRepaintBoundary boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        name: "id_card_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        Fluttertoast.showToast(
          msg: "ID Card saved to gallery",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to save ID Card",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print("Error saving ID card: $e");
      Fluttertoast.showToast(
        msg: "Error saving ID Card",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

// Custom painter for signature
class SignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black54
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    final path = Path();
    // Simple signature-like curve
    path.moveTo(size.width * 0.1, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.8,
      size.width * 0.9,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
