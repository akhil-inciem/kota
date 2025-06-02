import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/network_controller.dart';
import 'package:kota/views/network/no_internet_screen.dart';

class NetworkWrapper extends StatefulWidget {
  final Widget child;

  NetworkWrapper({required this.child});

  @override
  State<NetworkWrapper> createState() => _NetworkWrapperState();
}

class _NetworkWrapperState extends State<NetworkWrapper> {
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isConnected = Get.put(NetworkController()).isConnected.value;
      
      return Stack(
        children: [
          widget.child, // show the current screen as is
          if (!isConnected)
            Positioned.fill(
              child: Container( 
                color: Colors.white,
                child: NoInternetScreen(),
              ),
            ),
        ],
      );
    });
  }
}
