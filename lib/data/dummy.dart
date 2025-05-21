// This is where you store your dummy data for the app

import 'package:flutter/material.dart';
import 'package:kota/helper/date_helper.dart';
import 'package:kota/model/event_model.dart';
import 'package:kota/model/news_model.dart';

class DummyData {
  static const List<String> newsItems = [
    'Support for Nationwide Protest on August 17, 2024',
    'New Policy Announced for Healthcare Workers',
    'International Summit to Discuss Climate Change',
    'Revolutionary Advancements in AI Technology',
    'Local Elections and Key Candidate Discussions',
  ];

  static List<Map<String, dynamic>> recommendedItems = [
    {
      'badge': 'News',
    },
    {
      'badge': 'Forum',
    },
    {
      'badge': 'Event',
    },
  ];
}
