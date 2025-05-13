
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/views/home/events_detail_screen.dart';
import 'package:kota/views/home/widgets/list_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../news_detail_screen.dart';

class EventsList extends StatefulWidget {
  final bool isFavourite; // <--- New parameter
  final ScrollController scrollController;

  EventsList({
    Key? key,
    required this.isFavourite,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  final EventController eventController = Get.find<EventController>();

  String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\\[rnt]'), '')
        .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (eventController.isLoading.value) {
        return const ListShimmer(); // Show shimmer while loading
      }

      final items = eventController.filteredEventsItems;

      if (items.isEmpty) {
        return Center(
          child: Text(
            'No Events available',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        controller: widget.scrollController,
        itemCount: items.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventsDetailScreen(item: item),
                ),
              );
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // if (isFavourite) ...[
                                  //   Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 8,
                                  //       vertical: 4,
                                  //     ),
                                  //     decoration: BoxDecoration(
                                  //       color: getBadgeContainerColor(
                                  //         item.badges,
                                  //       ),
                                  //       borderRadius: BorderRadius.circular(8),
                                  //     ),
                                  //     child: Text(
                                  //       item.badges ?? 'Badge', // Badge Text
                                  //       style: TextStyle(
                                  //         fontSize: 10,
                                  //         color: getBadgeTextColor(item.badges),
                                  //       ),
                                  //     ),
                                  //   ),

                                  //   SizedBox(width: 2.w),
                                  // ],
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
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
                                          item.eventstartDateDate != null
                                              ? DateFormat(
                                                'dd MMM yyyy',
                                              ).format(item.eventstartDateDate!)
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF2640C8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                item.eventName ?? '',
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                _cleanText(item.eventDescription ?? ''),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 24.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child:
                                item.image == ''
                                    ? Image.asset(
                                      'assets/images/recommend_tile.jpg',
                                      fit:
                                          BoxFit
                                              .cover, // Ensure the image fits inside the box
                                    )
                                    : Image.network(
                                      item.image!,
                                      fit:
                                          BoxFit
                                              .cover, // Ensure the image fits inside the box
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade200, thickness: 1, height: 0),
              ],
            ),
          );
        },
      );
    });
  }
}
