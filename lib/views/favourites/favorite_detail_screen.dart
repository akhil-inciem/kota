import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/model/event_model.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  FavoritesDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<FavoritesDetailScreen> createState() => _FavoritesDetailScreenState();
}

class _FavoritesDetailScreenState extends State<FavoritesDetailScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final EventController eventController = Get.find<EventController>();
  final ValueNotifier<double> radiusNotifier = ValueNotifier<double>(30.0);
  final ValueNotifier<double> extentNotifier = ValueNotifier(0.6);

  bool _isSharing = false;

  void _handleShare() async {
    if (_isSharing) return; // Prevent repeated taps

    _isSharing = true;
    final title = widget.item['title'] ?? 'Check this out!';
    final params = ShareParams(
      title: title,
      uri: Uri.parse("https://dev.kbaiota.org/?favourites"),
    );
    SharePlus.instance.share(params);

    await Future.delayed(const Duration(milliseconds: 200));
    _isSharing = false;
  }

  String _htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.item["image"];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Stack(
          children: [
            // Background Image
            SizedBox(
              height: 40.h,
              width: double.infinity,
              child:
                  imageUrl != null
                      ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) =>
                                Container(color: Colors.grey[300]),
                        errorWidget:
                            (context, url, error) => Image.asset(
                              'assets/images/Group 315.png',
                              fit: BoxFit.cover,
                            ),
                      )
                      : Image.asset(
                        'assets/images/Group 315.png',
                        fit: BoxFit.cover,
                      ),
            ),
            // Draggable Scrollable Sheet
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                double extent = notification.extent;
                double percentage = (extent - 0.5) / (1.0 - 0.5);
                double radius = 30 * (1 - percentage.clamp(0.0, 1.0));
                radiusNotifier.value = radius;

                extentNotifier.value = extent; // 👈 add this
                return true;
              },

              child: DraggableScrollableSheet(
                initialChildSize: 0.6, // Start height
                minChildSize: 0.6, // Minimum when collapsed
                maxChildSize: 1, // Maximum when expanded
                builder: (context, scrollController) {
                  return ValueListenableBuilder<double>(
                    valueListenable: radiusNotifier,
                    builder: (context, radius, _) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(radius),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder<double>(
                                valueListenable: extentNotifier,
                                builder: (context, extent, _) {
                                  double topPadding =
                                      lerpDouble(
                                        4.h,
                                        8.h,
                                        ((extent - 0.6) / (1.0 - 0.6)).clamp(
                                          0.0,
                                          1.0,
                                        ),
                                      )!;
                                  return SizedBox(height: topPadding);
                                },
                              ),
                              _dateAndIcons(),
                              SizedBox(height: 2.h),
                              _title(),
                              SizedBox(height: 2.h),
                              _profileRow(),
                              SizedBox(height: 2.h),
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                                height: 0,
                              ),
                              SizedBox(height: 1.h),
                              // 👉 Now description scrolls separately
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: _description(),
                                ),
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Back button (Optional: if you want it floating)
            ValueListenableBuilder<double>(
              valueListenable: extentNotifier,
              builder: (context, extent, _) {
                double percentage = ((extent - 0.6) / (1.0 - 0.6)).clamp(
                  0.0,
                  1.0,
                );
                Color? iconColor =
                    percentage < 0.2
                        ? Colors.white
                        : AppColors
                            .primaryColor; // 👈 You can adjust 0.2 threshold

                return Positioned(
                  top: 1.h,
                  left: 0,
                  right: 10,
                  child: TopBar(title: "", onTap: () => Get.back()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateAndIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD3D8FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF2640C8),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                widget.item["date"] != null
                    ? DateFormat('dd MMM yyyy').format(widget.item['date']!)
                    : '',
                style: const TextStyle(fontSize: 10, color: Color(0xFF2640C8)),
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: _handleShare,
              child: Image.asset(
                'assets/icons/share.png',
                height: 2.5.h,
                width: 2.5.h, // use 2.h for both to maintain aspect ratio
              ),
            ),
            SizedBox(width: 3.w),
            // GestureDetector(
            //     onTap: () => homeController.toggleBookmark(widget.item[""]),
            //     child: Image.asset(
            //      isBookmarked
            //           ? 'assets/icons/saved.png'
            //           : 'assets/icons/favorites_unselected.png',
            //       height: 2.5.h,
            //       width: 2.5.h,
            //     ),
            //   )
          ],
        ),
      ],
    );
  }

  Widget _title() {
    return Text(
      widget.item['title'] ?? '',
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _profileRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'John Alexander',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              'President KOTA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _description() {
    String formattedDescription = widget.item['description'] ?? '';

    // Replace placeholders with actual HTML links
  for (var link in widget.item['descriptionLinks'] ?? []) {
    if (link.placeholder != null && link.url != null && link.label != null) {
      formattedDescription = formattedDescription.replaceAll(
        link.placeholder!,
        '<a href="${link.url}">${link.label}</a>',
      );
    }
  }

  // Replace \n and \t with <br> or just \n with <br>
  formattedDescription = formattedDescription.replaceAll(RegExp(r'[\n\t]+'), '<br>');

  return Html(
    data: formattedDescription,
    style: {
      "*": Style(
        fontSize: FontSize(15.sp),
        color: Colors.black54,
      ),
      "a": Style(
      color: AppColors.primaryColor, // Set link color
      textDecoration: TextDecoration.underline, // Optional: add underline
    ),
    },
    onLinkTap: (String? url, Map<String, String> attributes, dom.Element? element) {
      if (url != null) {
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    },
  );
  }
//   Widget _description(NewsDatum item) {
//   String formattedDescription = item.newsDescription ?? '';

//   // Replace placeholders with actual HTML links
//   for (var link in item.descriptionLinks ?? []) {
//     if (link.placeholder != null && link.url != null && link.label != null) {
//       formattedDescription = formattedDescription.replaceAll(
//         link.placeholder!,
//         '<a href="${link.url}">${link.label}</a>',
//       );
//     }
//   }

//   // Replace \n and \t with <br> or just \n with <br>
//   formattedDescription = formattedDescription.replaceAll(RegExp(r'[\n\t]+'), '<br>');

//   return Html(
//     data: formattedDescription,
//     style: {
//       "*": Style(
//         fontSize: FontSize(15.sp),
//         color: Colors.black54,
//       ),
//       "a": Style(
//       color: AppColors.primaryColor, // Set link color
//       textDecoration: TextDecoration.underline, // Optional: add underline
//     ),
//     },
//     onLinkTap: (String? url, Map<String, String> attributes, dom.Element? element) {
//       if (url != null) {
//         launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//       }
//     },
//   );
// }
}
