import 'package:ahorrala/providers/ItemsProvider.dart';

import '../theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ShimmerePlaceHolder.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/FavoritesProvider.dart';

class ProductItemGrid extends StatefulWidget {
  final String? sku;
  final String image;
  final String title;
  final double price;

  final String currency = "Gs. ";

  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onViewPressed;

  final bool showViewButton;

  final Color cardColor = Colors.white;
  final Color textColor = Colors.black;

  final double borderRadius;

  final int size;

  final double? imageHeight;

  const ProductItemGrid({
    super.key,

    required this.sku,

    required this.size,

    this.imageHeight,

    required this.image,

    required this.title,

    required this.price,

    this.onTap,

    this.onFavoritePressed,

    this.onViewPressed,

    this.showViewButton = true,

    this.borderRadius = AppConstants.radiusFull,
  });

  @override
  State<ProductItemGrid> createState() => _ProductItemGridState();
}

class _ProductItemGridState extends State<ProductItemGrid> {
  late double _imgheigth;

  late double _fontsize;

  late double _titleFontSize;

  String get heroTag {
    if (widget.sku != null && widget.sku!.isNotEmpty) {
      return 'ItemImage-${widget.sku}';
    }

    return 'ItemImage-${widget.image}';
  }

  @override
  void initState() {
    super.initState();

    if (widget.size == 2) {
      _imgheigth = 90;

      _fontsize = 12;
    } else if (widget.size == 3) {
      _imgheigth = 70;

      _fontsize = 10;
    } else {
      _imgheigth = 100;

      _fontsize = 13;
    }

    _titleFontSize = _fontsize - 2;

    if (_titleFontSize < 9) {
      _titleFontSize = 9;
    }

    if (widget.imageHeight != null) {
      _imgheigth = widget.imageHeight!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,

      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 0),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: const Color.fromARGB(243, 158, 157, 157),

              width: 0.8,
            ),

            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(184, 206, 231, 248),

                blurRadius: 12,

                offset: const Offset(0, 0.1),
              ),
            ],
          ),

          child: SizedBox(
            width: 180,

            height: 260,

            child: Card(
              margin: EdgeInsets.zero,

              elevation: 0,

              clipBehavior: Clip.antiAlias,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),

                        child: SizedBox(
                          height: _imgheigth - 2,

                          width: double.infinity,

                          child: Hero(
                            tag: heroTag,

                            child: CachedNetworkImage(
                              fit: BoxFit.contain,

                              imageUrl: widget.image,

                              progressIndicatorBuilder:
                                  (context, url, progress) =>
                                      const BannerPlaceholder(),

                              errorWidget: (context, url, error) => Image.network(
                                "https://app.ahorrala.com/public/images/image_place_holder.webp",

                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        right: -2,

                        top: -2,

                        child: Consumer<FavoritesProvider>(
                          builder: (context, favorites, child) {
                            final isFavorite =
                                widget.sku != null &&
                                favorites.isFavorite(widget.sku!);

                            return IconButton(
                              tooltip: isFavorite
                                  ? "${widget.title} esta en tu lista de Favoritos"
                                  : "agrega ${widget.title} a tu lista de Favoritos",

                              onPressed: () async {
                                if (widget.sku == null) {
                                  return;
                                }

                                await favorites.toggle(widget.sku!);
                                context
                                    .read<ItemsProvider>()
                                    .loadItemsFavorites(favorites.skus);
                                widget.onFavoritePressed?.call();
                              },

                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),

                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,

                                    child: child,
                                  );
                                },

                                child: Icon(
                                  size: 30,
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded,

                                  key: ValueKey(isFavorite),

                                  color: isFavorite
                                      ? Colors.red
                                      : const Color.fromARGB(255, 71, 70, 70),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2),

                            child: Text(
                              widget.title,

                              maxLines: 3,

                              textAlign: TextAlign.center,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: _titleFontSize + 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            Text(
                              '${widget.currency}${NumberFormat.decimalPattern("es_py").format(widget.price)}',

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: _fontsize + 1,

                                color: Color(0xFF10B981),
                              ),
                            ),

                            if (widget.showViewButton)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: ElevatedButton(
                                  onPressed: widget.onTap,

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,

                                    foregroundColor: Colors.white,

                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,

                                      vertical: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),

                                  child: Text(
                                    'Ver Oferta',

                                    style: TextStyle(fontSize: _fontsize + 1),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
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
