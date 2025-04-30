import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:kota/data/dummy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdvertisementList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16.5.h, // Set the height for the news list container
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  DummyData.newsItems.length, // Use the list from DummyData
              itemBuilder: (context, index) {
                return AdvertisementCard(
                  title:
                      DummyData
                          .newsItems[index], // Pass the title as a parameter
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdvertisementCard extends StatelessWidget {
  final String title;

  const AdvertisementCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: 80.w,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.deepPurple],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,

                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  '16 Aug 2024',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
