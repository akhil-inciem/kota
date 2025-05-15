import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

class ForumPostBody extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String likes;
  final String comments;
  // final bool isLiked;
  final VoidCallback onLikeToggle;

  const ForumPostBody({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    // required this.isLiked,
    required this.onLikeToggle,
  }) : super(key: key);

  @override
  State<ForumPostBody> createState() => _ForumPostBodyState();
}

class _ForumPostBodyState extends State<ForumPostBody> {
  late bool _liked;

  @override
  void initState() {
    super.initState();
    // _liked = widget.isLiked;
  }

  // void _handleLikeTap() {
  //   setState(() {
  //     _liked = !_liked;
  //   });
  //   widget.onLikeToggle();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
        SizedBox(height: 12),
        Text(widget.description,
            style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.5)),
        SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            widget.imageUrl,
            height: 17.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            GestureDetector(
              // onTap: _handleLikeTap,
              child: Icon(Icons.favorite,
                  size: 20,
                  //  color: _liked ? Colors.red : Colors.grey
                   ),
            ),
            SizedBox(width: 4),
            Text(widget.likes, style: TextStyle(fontSize: 14)),
            SizedBox(width: 20),
            Icon(Icons.comment, size: 20, color: Colors.grey),
            SizedBox(width: 4),
            Text('${widget.comments} Comments', style: TextStyle(fontSize: 14)),
            SizedBox(width: 20),
            GestureDetector(onTap: (){
              final title = widget.title ?? 'Check this out!';
                final params = ShareParams(
                  title: title,
                  uri: Uri(scheme: 'https', host: 'crash.net'),
                );
                SharePlus.instance.share(params);
            },child: Icon(Icons.share, size: 20, color: Colors.grey)),
            SizedBox(width: 4),
            Text('Share', style: TextStyle(fontSize: 14)),
          ],
        ),
        SizedBox(height: 1.5.h),
        Divider(),
      ],
    );
  }
}
