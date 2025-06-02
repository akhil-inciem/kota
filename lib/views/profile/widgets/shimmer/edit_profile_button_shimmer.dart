import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerButtonPlaceholder extends StatelessWidget {
  const ShimmerButtonPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
