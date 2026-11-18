import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductItemList extends StatelessWidget {
  final String? sku;
  final String image;
  final String title;
  final double price;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final int size;

  // Propiedades fijas movidas a constantes o configuraciones limpias
  final String currency = "Gs. ";
  final Color cardColor = Colors.white;
  final Color textColor = Colors.black;
  final double borderRadius = 8.0;

  // Tamaños fijos para evitar lógica innecesaria en el initState
  final double _imageWidth = 80;
  final double _imageHeight = 100;

  const ProductItemList({
    super.key,
    required this.sku,
    required this.size,
    required this.image,
    required this.title,
    required this.price,
    this.onTap,
    this.onFavoritePressed,
    required String category,
    required int category_id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        // Reemplaza GestureDetector para dar feedback visual de toque
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Imagen a la izquierda con bordes redondeados
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - 2),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: _imageWidth,
                  height: _imageHeight,
                  fit: BoxFit
                      .cover, // Cover es mejor que fill para no deformar la imagen
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),

              // 2. Información a la derecha (Título, Precio y Botón)
              Expanded(
                child: SizedBox(
                  height: _imageHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 14.0,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 4.0),

                      // Bloque de Precio y Botón "Ver"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Consumer<FavoritesProvider>(
                            builder: (context, favorites, child) {
                              final isFavorite =
                                  sku != null && favorites.isFavorite(sku!);

                              return IconButton(
                                tooltip: isFavorite
                                    ? "$title esta en tu lista de Favoritos"
                                    : "agrega $title a tu lista de Favoritos",

                                onPressed: () async {
                                  if (sku == null) {
                                    return;
                                  }

                                  await favorites.toggle(sku!);

                                  context
                                      .read<ItemsProvider>()
                                      .loadItemsFavorites(favorites.skus);
                                  onFavoritePressed?.call();
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
                          Flexible(
                            child: Text(
                              // "$currency${price.toStringAsFixed(0)}",
                              '$currency${NumberFormat.decimalPattern("es_py").format(price)}',

                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          ElevatedButton(
                            onPressed: onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11.0,
                                vertical: 5.0,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: const Text(
                              'Ver Oferta',
                              style: TextStyle(fontSize: 13.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
