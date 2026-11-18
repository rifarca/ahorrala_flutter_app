import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../helpers/helper.dart';
import '../models/Items.dart';
import 'ProductItemGrid.dart';
import 'ShimmerProductItemGrid.dart';

Widget buildProductItemsCategoriesListHorizontal(
  BuildContext ctx,
  int cat,
  int sub,
  int limit,
) {
  final CategoryName = Helper.getCategoryNameById(cat);
  final CategoriyImage = Helper.getCategoryImageById(cat);
  final category = Helper.getCategoryByID(cat);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(CategoriyImage, width: 50, height: 50),
                  Text(
                    CategoryName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () {
                      ctx.push("/categorias/$cat", extra: category);
                    },
                    child: const Text('ver todo..'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        child: FutureBuilder<List<Items>>(
          future: Helper.getItemsListByCategory(cat: cat, sub: 1, limit: limit),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
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
                        child: ShimmerProductItemGrid(width: 175, height: 260),
                      ),
                    );
                  },
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final items = snapshot.data;
            if (items == null || items.isEmpty) {
              return const Center(child: Text('No hay datos'));
            }

            return Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final rawItem = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 175,
                      height: 260,
                      child: ProductItemGrid(
                        size: 1,
                        image: rawItem.Imagen,
                        title: rawItem.Titulo,
                        price: rawItem.PrecioNuevo.toDouble(),
                        sku: rawItem.Sku,
                        onTap: () {
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

                          String title = Helper.sanitizeToFriendlyUrl(
                            rawItem.Titulo,
                          );
                          ctx.push('/items/${rawItem.Sku}/$title', extra: item);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget buildProductItemsRelativesListHorizontal(
  BuildContext ctx,
  int cat,
  int sub,
  int limit,
) {
  final categoryColor = Helper.getColorByCategoryId(cat);
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 12.0),
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.tag_solid, size: 30),
                  ),
                  const Text(
                    'Productos Relacionados',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(),
                  child: SizedBox(
                    height: 1,
                    child: ColoredBox(color: categoryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 280,
        child: FutureBuilder<List<Items>>(
          future: Helper.getItemsListByCategory(cat: cat, sub: 1, limit: limit),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: SizedBox(
                        width: 175,
                        height: 260,
                        child: ShimmerProductItemGrid(width: 175, height: 260),
                      ),
                    );
                  },
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final items = snapshot.data;
            if (items == null || items.isEmpty) {
              return const Center(child: Text('No hay datos'));
            }

            return Padding(
              padding: const EdgeInsets.all(7),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final rawItem = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SizedBox(
                      width: 175,
                      height: 260,
                      child: ProductItemGrid(
                        size: 1,
                        image: rawItem.Imagen,
                        title: rawItem.Titulo,
                        price: rawItem.PrecioNuevo.toDouble(),
                        sku: rawItem.Sku,
                        onTap: () {
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

                          String title = Helper.sanitizeToFriendlyUrl(
                            rawItem.Titulo,
                          );
                          ctx.push('/items/${rawItem.Sku}/$title', extra: item);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    ],
  );
}
