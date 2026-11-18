// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BranditemGrid extends StatefulWidget {
  /// A callback function triggered when the card is tapped.
  final VoidCallback? onTap;
  final int marca_id;
  final String marca;
  final String imagen;
  const BranditemGrid({
    super.key,
    required this.marca_id,
    required this.marca,
    required this.imagen,
    this.onTap,
  });

  @override
  State<BranditemGrid> createState() => _BranditemGridState();
}

class _BranditemGridState extends State<BranditemGrid> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        shadowColor: Colors.blueAccent,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // el propducto esta pensado para usarse en 2por fila en na grilla
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Builder(
                      builder: (context) {
                        try {
                          return Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  child: Image(
                                    image: AssetImage(widget.imagen),

                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(widget.marca),
                            ],
                          );
                        } catch (e) {
                          // Handle error
                          return const Center(
                            child: Image(
                              image: CachedNetworkImageProvider(
                                "https://app.ahorrala.com/public/images/image_place_holder.webp",
                              ),
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Product detail
          ],
        ),
      ),
    );
  }
}
