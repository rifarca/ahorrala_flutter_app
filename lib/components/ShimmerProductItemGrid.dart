import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductItemGrid extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerProductItemGrid({
    super.key,
    this.width = 175,
    this.height = 260,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: Border.all(
            color: const Color.fromARGB(255, 174, 206, 231),
            width: .5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: const Color.fromARGB(255, 245, 245, 245),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: (height * 0.36).clamp(50.0, 140.0),
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  Container(height: 14, width: 80, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(
                    height: 32,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
