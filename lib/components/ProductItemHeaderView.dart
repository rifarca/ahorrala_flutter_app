import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'ShimmerePlaceHolder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductItemHeaderView extends StatefulWidget {
  /// The unique identifier of the product.
  final String? sku;

  /// The URL of the product image.
  final String image;

  /// The name of the product.
  final String title;

  /// The price of the product.
  final double price;

  /// The currency symbol used for the price.
  final String currency = "Gs. ";

  /// A callback function triggered when the card is tapped.
  final VoidCallback? onTap;

  /// Whether to wrap the image in a Hero widget.
  final bool enableHero;

  /// A callback function triggered when the favorite button is pressed.
  VoidCallback? onFavoritePressed;

  /// The background color of the card.
  final Color cardColor = const Color.fromARGB(255, 223, 226, 239);

  /// The text color used for labels and descriptions.
  final Color textColor = Colors.black;

  /// The border radius of the card.
  double borderRadius = 10;
  int category_id = 3;
  String category = "Higiene Persoonal";
  ProductItemHeaderView({
    super.key,
    required this.sku,
    required this.image,
    required this.title,
    required this.price,
    required this.category_id,
    required this.category,
    this.onTap,
    this.enableHero = true,
  });

  @override
  _ProductItemHeaderViewState createState() => _ProductItemHeaderViewState();
}

class _ProductItemHeaderViewState extends State<ProductItemHeaderView> {
  String get heroTag {
    if (widget.sku != null && widget.sku!.isNotEmpty) {
      return 'ItemImage-${widget.sku}';
    }
    return 'ItemImage-${widget.image}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // el propducto esta pensado para usarse en 2por fila en na grilla
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Builder(
                  builder: (context) {
                    try {
                      final imageWidget = CachedNetworkImage(
                        height: 250,
                        fit: BoxFit.fitHeight,
                        imageUrl: widget.image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                BannerPlaceholder(),
                        errorWidget: (context, url, error) => Image(
                          image: CachedNetworkImageProvider(
                            "https://app.ahorrala.com/public/images/image_place_holder.webp",
                          ),
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      );

                      return widget.enableHero
                          ? Hero(tag: heroTag, child: imageWidget)
                          : imageWidget;
                    } catch (e) {
                      // Handle error
                      return Center(child: Text('Failed to load image'));
                    }
                  },
                ),
                Positioned(
                  right: 1,

                  top: 1,

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
                          context.read<ItemsProvider>().loadItemsFavorites(
                            favorites.skus,
                          );
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
                Positioned(
                  left: 1,

                  top: 1,

                  child: IconButton(
                    onPressed: () async {
                      if (widget.sku == null) {
                        return;
                      }
                      final url =
                          "https://deeplinks.ahorrala.com/item/${widget.sku}";

                      final params = ShareParams(uri: Uri.parse(url));

                      SharePlus.instance.share(params);
                    },

                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),

                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },

                      child: Icon(
                        size: 30,
                        Icons.share,

                        color: const Color.fromARGB(255, 71, 70, 70),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // titulo o nombre del producto
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  // Short description (if provided)
                  SizedBox(height: 5),
                  //codiugo de barra
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* const Icon(
                          CupertinoIcons.barcode,
                          color: Color.fromARGB(255, 44, 40, 40),
                          size: 24,
                          applyTextScaling: true,
                        ),*/
                      // Product price
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Categoria:"),
                            InkWell(
                              child: Text(
                                widget.category,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                context.push("category/");
                              },
                            ),
                            SizedBox(width: 10),

                            Text("SKU:"),

                            Text(
                              '${widget.sku}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
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
    );
  }
}
