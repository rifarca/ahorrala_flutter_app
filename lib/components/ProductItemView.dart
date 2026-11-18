import 'package:flutter/material.dart';

import 'ProductItemGrid.dart';

class ProductItemView extends StatelessWidget {
  /// The unique identifier of the product.
  final String? sku;

  /// The URL of the product image.
  final String image;

  /// The name of the product.
  final String title;

  /// The price of the product.
  final double price;

  /// A callback function triggered when the card is tapped.
  final VoidCallback? onTap;

  const ProductItemView({
    super.key,
    this.sku,
    required this.image,
    required this.title,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProductItemGrid(
      sku: sku,
      size: 1,
      imageHeight: 140,
      borderRadius: 0,
      image: image,
      title: title,
      price: price,
      showViewButton: false,
      onTap: onTap,
    );
  }
}
