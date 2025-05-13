import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/views/home/news_detail_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: DummyData.recommendedItems.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = DummyData.recommendedItems[index];
        return GestureDetector(
          onTap: () {},
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
                            SizedBox(height: 1.h),
                            Text(
                              item['title'] ?? '',
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              item['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 6.w,vertical: 0.5.h),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD3D8FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: 
                                        Text(
  item['date'] != null 
      ? DateFormat('dd MMM yyyy').format(item['date']) 
      : '', 
  style: const TextStyle(fontSize: 10, color: Color(0xFF2640C8)),
)
                                  ),
                   ],
                 ),
               ),
               SizedBox(height: 1.h,),
              Divider(color: Colors.grey.shade200, thickness: 1, height: 0),
              SizedBox(height: 1.h),
            ],
          ),
        );
      },
    );
  }
}
