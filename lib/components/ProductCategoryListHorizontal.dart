import 'ProductItemGrid.dart';
import 'ShimmerProductItemGrid.dart';
import '../models/Items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Asumiendo que usas go_router por el .push()

import '../helpers/helper.dart';

class ProductCategoryListHorizontal extends StatelessWidget {
  final int cat;
  final int sub;
  final int limit;
  final Future<List<Items>> futureItems; // Aquí recibimos el Future ya cacheado

  const ProductCategoryListHorizontal({
    super.key,
    required this.cat,
    required this.sub,
    required this.limit,
    required this.futureItems,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Estas asignaciones sincrónicas son seguras aquí
    final categoryName = Helper.getCategoryNameById(cat);
    final categoryImage = Helper.getCategoryImageById(cat);
    final category = Helper.getCategoryByID(cat);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Encabezado de la Categoría
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(categoryImage, width: 46, height: 36),
              // const SizedBox(width: 8), // Pequeño espacio estético
              Expanded(
                child: Text(
                  categoryName,
                  textAlign: TextAlign
                      .left, // Cambiado a left para mejor flujo con el botón
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    context.push("/categorias/$cat", extra: category),
                child: const Text(
                  'ver todo..',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),

        // Lista Horizontal con FutureBuilder Optimizado
        SizedBox(
          height: 260, // Altura fija para la lista horizontal
          child: FutureBuilder<List<Items>>(
            future:
                futureItems, // 2. IMPORTANTE: Usa el Future del padre, NO LLAMES al Helper aquí
            builder: (context, snapshot) {
              // Estado de carga inicial (Esperando datos)
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 175,
                          height: 260,
                          child: ShimmerProductItemGrid(
                            width: 175,
                            height: 260,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              // Manejo de errores de red o servidor
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error al cargar productos: ${snapshot.error}'),
                );
              }

              // Validar si la lista llegó vacía o nula
              final items = snapshot.data;
              if (items == null || items.isEmpty) {
                return const Center(child: Text('No hay datos'));
              }

              // Renderizado eficiente de la lista de productos
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final rawItem = items[index];

                  return SizedBox(
                    width: 175,
                    height: 260,
                    child: ProductItemGrid(
                      size: 1,
                      image: rawItem.Imagen,
                      title: rawItem.Titulo,
                      price: rawItem.PrecioNuevo.toDouble(),
                      sku: rawItem.Sku,
                      onTap: () {
                        // 3. Optimización: No reconstruyas un objeto idéntico manualmente si ya lo tienes
                        final item = Items(
                          Sku: rawItem.Sku,
                          Titulo: rawItem.Titulo,
                          Imagen: rawItem.Imagen,
                          CategoriaID: rawItem.CategoriaID,
                          CategoriaNombre: rawItem.CategoriaNombre,
                          SubcategoriaNombre: rawItem.SubcategoriaNombre,
                          SubcategoriaID: rawItem.CategoriaID,
                          NegocioID: rawItem.NegocioID,
                          NegocioNombre: rawItem.NegocioNombre,
                          PrecioNuevo: rawItem.PrecioNuevo,
                          PrecioViejo: rawItem.PrecioViejo,
                          PrecioOff: rawItem.PrecioOff,
                          Link: rawItem.Link,
                        );

                        String friendlyTitle = Helper.sanitizeToFriendlyUrl(
                          rawItem.Titulo,
                        );
                        context.push(
                          '/items/${rawItem.Sku}/$friendlyTitle',
                          extra: item,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
