import 'package:flutter/material.dart';
import 'package:ahorrala/components/ShimmerePlaceHolder.dart';

class FavoriteItemShimmer extends StatelessWidget {
  const FavoriteItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      child: const Row(
        children: [
          SizedBox(width: 110, height: 110, child: BannerPlaceholder()),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 18,
                  width: double.infinity,
                  child: BannerPlaceholder(),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 18,
                  width: double.infinity,
                  child: BannerPlaceholder(),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 24,
                    width: 100,
                    child: BannerPlaceholder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
