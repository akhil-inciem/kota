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

  

  static List<String> comments = [
    'As an occupational therapist, I see firsthand how small changes can make a big difference in a persons daily life. Helping individuals regain confidence and independence through meaningful activities is at the heart of what we do.',
    'Its amazing to see how even small adjustments can help someone feel more independent. Thats what I love about OT-helping people get back to the things they love doing.',
    'Occupational therapy enables clients to regain functional independence through evidence-based interventions, adaptive strategies, and holistic care tailored to their daily life needs.'
  ];

  static Map<String,dynamic> events = {
    "status": true,
    "message": "News fetched successfully",
    "data": [
        {
            "event_id": "3",
            "event_title": "2",
            "event_name": "PROFESSIONAL MEETUP",
            "event_short_description": "Zonal Professional Meet",
            "event_description": "\r\n\tProfessional Meetup of Occupational Therapists of Kochi, Alappuzha and Thrissur on 19.02.2023.\r\n",
            "eventstart_date_date": "2025-02-19",
            "event_end_date": "2023-02-19",
            "total_seats": "0",
            "added_by": "25",
            "added_on": "0000-00-00 00:00:00",
            "image": "f2e2b-67523-kota-meeting.jpg",
            "document": "",
            "status": "1",
            "fees_per_seat": "0",
            "location": "",
            "online_booking": "1",
            "badges": null,
            "faverites": null
        },
        {
            "event_id": "4",
            "event_title": "0",
            "event_name": "OT Day 2022",
            "event_short_description": "OT Day Celebrations at Mascot Hotel Trivandrum",
            "event_description": "\r\n\tOT Day Celebrations at Mascot Hotel Trivandrum. Click here for photos of the event.\r\n",
            "eventstart_date_date": "2025-10-27",
            "event_end_date": "2022-10-27",
            "total_seats": "0",
            "added_by": "25",
            "added_on": "0000-00-00 00:00:00",
            "image": "beaf5-otday22-13.jpg",
            "document": "",
            "status": "1",
            "fees_per_seat": "0",
            "location": "",
            "online_booking": "2",
            "badges": null,
            "faverites": null
        },
        {
            "event_id": "5",
            "event_title": "1",
            "event_name": "Annual Health Conference",
            "event_short_description": "A gathering of healthcare professionals to discuss the latest advancements.",
            "event_description": "\r\n\tThe Annual Health Conference in Mumbai, featuring top doctors, speakers, and workshops for medical professionals.\r\n",
            "eventstart_date_date": "2025-05-10",
            "event_end_date": "2024-05-12",
            "total_seats": "300",
            "added_by": "30",
            "added_on": "2023-04-25 14:30:00",
            "image": "annual-health-conference.jpg",
            "document": "health-conference-schedule.pdf",
            "status": "1",
            "fees_per_seat": "1000",
            "location": "Mumbai, India",
            "online_booking": "1",
            "badges": "New Event",
            "faverites": "yes"
        },
        {
            "event_id": "6",
            "event_title": "3",
            "event_name": "Tech Innovations 2023",
            "event_short_description": "Technology conference for innovators and tech enthusiasts.",
            "event_description": "\r\n\tJoin us for a 3-day event showcasing cutting-edge technology and innovations from around the world.\r\n",
            "eventstart_date_date": "2025-06-01",
            "event_end_date": "2023-06-03",
            "total_seats": "500",
            "added_by": "32",
            "added_on": "2023-05-10 09:00:00",
            "image": "tech-innovations-2023.jpg",
            "document": "tech-innovations-brochure.pdf",
            "status": "1",
            "fees_per_seat": "1500",
            "location": "Bangalore, India",
            "online_booking": "1",
            "badges": "Early Bird",
            "faverites": "no"
        },
        {
            "event_id": "7",
            "event_title": "4",
            "event_name": "Digital Marketing Summit",
            "event_short_description": "Summit for digital marketers to explore new strategies and tools.",
            "event_description": "\r\n\tThe Digital Marketing Summit will bring together the brightest minds in the industry to share strategies, case studies, and insights.\r\n",
            "eventstart_date_date": "2025-07-10",
            "event_end_date": "2023-07-12",
            "total_seats": "200",
            "added_by": "35",
            "added_on": "2023-06-01 10:30:00",
            "image": "digital-marketing-summit.jpg",
            "document": "digital-marketing-schedule.pdf",
            "status": "1",
            "fees_per_seat": "1200",
            "location": "New Delhi, India",
            "online_booking": "2",
            "badges": "Featured",
            "faverites": "yes"
        }
    ]
};

  static Map<String, dynamic> news = {
  "status": true,
  "message": "News fetched successfully",
  "data": [
    {
      "news_id": "5",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },
    {
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },{
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },{
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },{
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },{
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },{
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },{
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": false
    },{
      "news_id": "4",
      "news_title": "World Occupational Therapy Day",
      "news_sub_title": "World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum, ",
      "news_description": "Following the grand success of the “world Occupational Therapy Day” celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt ‘Thank you&#39; to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.\r\n\r\n\tFor more PHOTOS check here.\r\n\r\n\tFor VIDEOS check here.\r\n\r\n\tPresident\r\n\r\n\tKOTA\r\n",
      "news_image": "https://kbaiota.org/assets/uploads/files/beaf5-otday22-13.jpg",
      "news_date": "2022-11-16",
      "attachment": "",
      "added_on": "0000-00-00 00:00:00",
      "added_by": "25",
      "status": "1",
      "news_category": "1",
      "author": null,
      "news_author": "JOSEPH SUNNY",
      "badges": "4",
      "faverites": true
    },
  ]
};

  static List<Map<String, String>> forumItems = [
    {
      'name': 'Sushant Rana',
      'time': '4',
      'title':
          'How does occupational therapy support individuals in regaining independence in their daily activities after an injury or illness?',
      'description':
          'Occupational therapy (OT) helps individuals regain independence after illness or injury by focusing on daily tasks like dressing, cooking, or working. Therapists begin with a personalized assessment to identify challenges, then create tailored plans to rebuild skills. They introduce adaptive tools and techniques to make tasks easier and safer. OT also offers cognitive and emotional support, helping with memory, focus, and coping. In addition, therapists suggest home or work modifications to reduce barriers. Overall, OT empowers people to live more independently and confidently in their everyday lives.',
      'likes': '29',
      'comments': '5',
    },
    {
      'name': 'Samatha Raj',
      'time': '10',
      'title':
          'How does occupational therapy support individuals in regaining independence in their daily activities after an injury or illness?',
      'description':
          'Occupational therapy (OT) helps individuals regain independence after illness or injury by focusing on daily tasks like dressing, cooking, or working. Therapists begin with a personalized assessment to identify challenges, then create tailored plans to rebuild skills. They introduce adaptive tools and techniques to make tasks easier and safer. OT also offers cognitive and emotional support, helping with memory, focus, and coping. In addition, therapists suggest home or work modifications to reduce barriers. Overall, OT empowers people to live more independently and confidently in their everyday lives.',
      'likes': '02',
      'comments': '10',
    },
    {
      'name': 'Samay Sundaram',
      'time': '10',
      'title':
          'How does occupational therapy support individuals in regaining independence in their daily activities after an injury or illness?',
      'description':
          'Occupational therapy (OT) helps individuals regain independence after illness or injury by focusing on daily tasks like dressing, cooking, or working. Therapists begin with a personalized assessment to identify challenges, then create tailored plans to rebuild skills. They introduce adaptive tools and techniques to make tasks easier and safer. OT also offers cognitive and emotional support, helping with memory, focus, and coping. In addition, therapists suggest home or work modifications to reduce barriers. Overall, OT empowers people to live more independently and confidently in their everyday lives.',
      'likes': '02',
      'comments': '5',
    },
  ];

  static List<Map<String, dynamic>> recommendedItems = [
    {
      'badge': 'News',
      'title':
          'World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum',
      'description':
          'Following the grand success of the "world Occupational Therapy Day" celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt '
          'Thank you'
          ' to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks 6 1x to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.',
      'date': parseDate('2025-04-23'),
    },
    {
      'title':
          'World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum',
      'description':
          'Following the grand success of the "world Occupational Therapy Day" celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt '
          'Thank you'
          ' to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks 6 1x to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.',
      'date': parseDate('2024-08-16'),
      'badge': 'Forum',
    },
    {
      'title':
          'World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum',
      'description':
          'Following the grand success of the "world Occupational Therapy Day" celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt '
          'Thank you'
          ' to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks 6 1x to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.',
      'date': parseDate('2024-08-16'),
      'badge': 'Event',
    },
    {
      'title':
          'World OT Day celebrations on 27th October 2022 at Mascot Hotel, Trivandrum',
      'description':
          'Following the grand success of the "world Occupational Therapy Day" celebrations held on the 27th of October 2022 at Mascot Hotel, Trivandrum, I would like to take this opportunity to thank all those who took their time and effort to participate and make this event a memorable one. I would like to extend my sincere gratitude to all the KOTA executive committee members for their relentless efforts in upholding the vision and mission of our Association. My heartfelt '
          'Thank you'
          ' to all the KOTA members and the organizing committee for their proactive and enthusiastic involvement from the start to the conclusion of the event. I would also like to thank NISH and NIPMR faculties and students and my fellow therapists for their participation. The event is a success thanks 6 1x to all your involvement and enthusiasm. We hope to have many more such events in the future and hope that you will continue to render your support and encouragement.',
      'date': parseDate('2024-09-16'),
      'badge': 'Case Study',
    },
  ];

  static const String latestNewsTitle = 'Latest News';
  static const String initialAvatar = 'https://ui-avatars.com/api/?name=Joseph+Nicholas&size=300&background=random&color=fff';
  static const String adorableAvatar = 'https://api.dicebear.com/7.x/adventurer/png?seed=JohnDoe';
}
