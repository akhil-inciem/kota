import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kota/model/executive_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:kota/constants/colors.dart';
import 'package:share_plus/share_plus.dart';

class ExecutiveCard extends StatelessWidget {
  final LeadersDetail executive;

  const ExecutiveCard({super.key, required this.executive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Circular Image
          ClipRRect(
            borderRadius: BorderRadius.circular(2.w),
            child: CachedNetworkImage(
              imageUrl: executive.portalImage ?? '',
              width: 30.w,
              height: 35.w,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    width: 30.w,
                    height: 35.w,
                    color: Colors.grey[300],
                  ),
              errorWidget:
                  (context, url, error) => Icon(Icons.error, color: Colors.red),
            ),
          ),
          SizedBox(width: 4.w),

          // Info Section
          Expanded(
            child: SizedBox(
              height: 35.w, // Match image height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top: Name, Designation, Share
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${executive.firstName ?? ''} ${executive.lastName ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              executive.designation ?? '',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Bottom: Divider, Contact Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1, color: Colors.grey[300]),
                      Text(
                        executive.officialMobile ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        executive.officialEmail ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
