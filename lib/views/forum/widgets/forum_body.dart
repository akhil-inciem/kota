import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumPostBody extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String likes;
  final String comments;

  const ForumPostBody({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        // Description
        Text(
          description,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        SizedBox(height: 16),
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imageUrl,
            height: 17.h, // Replace with 20.h if using Sizer
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16),
        // Like, Comments, Share Row
        Row(
          children: [
            Icon(Icons.favorite, size: 20, color: AppColors.primaryText),
            SizedBox(width: 4),
            Text(likes, style: const TextStyle(fontSize: 14)),
            SizedBox(width: 20),
            Icon(Icons.comment, size: 20, color: Colors.grey),
            SizedBox(width: 4),
            Text('$comments Comments', style: const TextStyle(fontSize: 14)),
            SizedBox(width: 20),
            Icon(Icons.share, size: 20, color: Colors.grey),
            SizedBox(width: 4),
            Text('Share', style: const TextStyle(fontSize: 14)),
          ],
        ),
        SizedBox(height: 1.5.h),
        Divider(),
      ],
    );
  }
}
