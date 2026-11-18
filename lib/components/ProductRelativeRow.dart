import 'ProductItemGrid.dart';
import '../helpers/helper.dart';
import '../models/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductRelativesRow extends StatelessWidget {
  final int cat;

  final List<Items> relatives;

  const ProductRelativesRow({
    super.key,

    required this.cat,

    required this.relatives,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = Helper.getColorByCategoryId(cat);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: 8),

                    child: Icon(CupertinoIcons.tag_solid, size: 26),
                  ),

                  Text(
                    'Productos Relacionados',

                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                child: SizedBox(
                  height: 2,

                  child: ColoredBox(color: categoryColor),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 260,

          child: relatives.isEmpty
              ? const Center(child: Text("No hay productos relacionados"))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: relatives.length,

                  itemBuilder: (context, index) {
                    final item = relatives[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 5),

                      child: SizedBox(
                        width: 180,

                        child: ProductItemGrid(
                          size: 1,

                          image: item.Imagen,

                          title: item.Titulo,

                          price: item.PrecioNuevo.toDouble(),

                          sku: item.Sku,

                          onTap: () {
                            context.push(
                              '/items/${item.Sku}/${Helper.sanitizeToFriendlyUrl(item.Titulo)}',

                              extra: item,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
