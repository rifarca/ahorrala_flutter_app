import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryitemGrid extends StatefulWidget {
  /// A callback function triggered when the card is tapped.
  final VoidCallback? onTap;
  final int categoria_id;
  final String categoria;
  final String imagen;
  const CategoryitemGrid({
    super.key,
    required this.categoria_id,
    required this.categoria,
    required this.imagen,
    this.onTap,
  });

  @override
  State<CategoryitemGrid> createState() => _CategoryitemGridState();
}

class _CategoryitemGridState extends State<CategoryitemGrid> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // el propducto esta pensado para usarse en 2por fila en na grilla
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Builder(
                  builder: (context) {
                    try {
                      return Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
                          child: SizedBox(
                            width: 180,
                            height: 160,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0,
                                    vertical: 12.0,
                                  ),
                                  child: Image(
                                    image: AssetImage(widget.imagen),
                                    height: 88,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 14.0,
                                  ),
                                  child: Text(
                                    widget.categoria,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } catch (e) {
                      return const Center(
                        child: Image(
                          image: CachedNetworkImageProvider(
                            "https://app.ahorrala.com/public/images/image_place_holder.webp",
                          ),
                          height: 80,
                          fit: BoxFit.fill,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Product detail
        ],
      ),
    );
  }
}
