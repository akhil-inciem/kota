import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ForumPostBody extends StatefulWidget {
  final String title;
  final String description;
  final List<String> imageUrls;
  final RxBool isLiked;
final RxString likes;
final String id;
final RxString comments;

  final VoidCallback onLikeToggle;

  const ForumPostBody({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.id,
    required this.onLikeToggle,
  }) : super(key: key);

  @override
  State<ForumPostBody> createState() => _ForumPostBodyState();
}

class _ForumPostBodyState extends State<ForumPostBody> {
  final PageController _pageController = PageController();
  final ForumController controller = Get.find<ForumController>();
  
  String getForumShareUrl(String forumId) {
  return Platform.isIOS
      ? "https://dev.kbaiota.org/forum/$forumId"
      : "https://dev.kbaiota.org/?forum/$forumId";
}

  bool _isSharing = false;

  void _handleShare() async {
    if (_isSharing) return;

    _isSharing = true;

    final title = widget.title ?? 'Check this out!';
    final params = ShareParams(
      title: title,
      uri: Uri.parse("https://dev.kbaiota.org/?forum/${widget.id}"),
    );
    SharePlus.instance.share(params);

    await Future.delayed(const Duration(milliseconds: 200));
    _isSharing = false;
  }
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.imageUrls.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.description,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Horizontal Image Scroll with Page Indicator
        if (hasImages) ...[
          SizedBox(
            height: 50.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: CachedNetworkImage(
    imageUrl: widget.imageUrls[index],
    width: double.infinity,
    fit: BoxFit.fitWidth,
    placeholder: (context, url) => Container(
      height: 200, // adjust if needed
      color: Colors.grey[300],
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
  ),
);
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.imageUrls.length,
              effect: WormEffect(
                activeDotColor: AppColors.primaryColor,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Like, Comment, Share Row
        Row(
  children: [
    GestureDetector(
      onTap: widget.onLikeToggle,
      child: Obx(() => Icon(
        widget.isLiked.value ? Icons.favorite : Icons.favorite_border,
        size: 20,
        color: widget.isLiked.value ? Colors.red : Colors.black,
      )),
    ),
    const SizedBox(width: 4),
    Obx(() => Text(widget.likes.value, style: const TextStyle(fontSize: 14))),
    const SizedBox(width: 20),
    Row(
      children: [
        const Icon(Icons.comment, size: 20, color: Colors.grey),
        const SizedBox(width: 4),
        Obx(() => Text(
          '${widget.comments} Comments',
          style: const TextStyle(fontSize: 14),
        )),
      ],
    ),
    const SizedBox(width: 20),
    GestureDetector(
      onTap: _handleShare,
      behavior: HitTestBehavior.opaque, // Ensures tap works on padding areas too
      child: Row(
        children: const [
          Icon(Icons.share, size: 20, color: Colors.grey),
          SizedBox(width: 4),
          Text('Share', style: TextStyle(fontSize: 14)),
        ],
      ),
    )
  ],
),

        SizedBox(height: 1.5.h),
        const Divider(),
      ],
    );
  }
}
