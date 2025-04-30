import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReplyTile extends StatelessWidget {
  final String userName;
  final String comment;

  const ReplyTile({
    Key? key,
    required this.userName,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile & Name
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'KOTA Member',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comment text
          Text(
            comment,
            style: const TextStyle(fontSize: 13,color: Colors.black54),
          ),
          const SizedBox(height: 8),
          // Actions Row
          Row(
            children: const [
              Icon(Icons.favorite_outline, size: 20, color: Colors.black), // or AppColors.primaryText
              SizedBox(width: 20),
              Icon(Icons.reply_sharp, size: 20, color: Colors.grey),
              SizedBox(width: 4),
              Text('Reply', style: TextStyle(fontSize: 14)),
            ],
          ),
          SizedBox(height:1.h)
,          Divider()
        ],
      ),
    );
  }
}
