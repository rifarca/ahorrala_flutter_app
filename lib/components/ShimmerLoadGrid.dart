// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadGrid extends StatefulWidget {
  const ShimmerLoadGrid({super.key});

  @override
  _ShimmerLoadGridState createState() => _ShimmerLoadGridState();
}

class _ShimmerLoadGridState extends State<ShimmerLoadGrid> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(width: 185, height: 200),
      ),
    );
  }
}
