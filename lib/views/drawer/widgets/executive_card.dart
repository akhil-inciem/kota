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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Executive Image
       ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: CachedNetworkImage(
    imageUrl: executive.portalImage!,
    width: double.infinity,
    height: 18.h,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(
      color: Colors.grey[300],
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
  ),
),


        // Info Section
        Container(
          height: 17.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                executive.designation ?? '',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),

              /// First name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        executive.firstName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        executive.lastName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.share, size: 18.sp),
                    onPressed: () {
                      final title = 'Check this out!';
                      final params = ShareParams(
                        title: title,
                        uri: Uri.parse("https://dev.kbaiota.org/executive"),
                      );
                      SharePlus.instance.share(
                        params,
                      ); // or however you're sharing
                    },
                  ),
                ],
              ),
              Text(
                executive.officialMobile ?? '',
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
              ),
              Text(
                executive.officialEmail ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
