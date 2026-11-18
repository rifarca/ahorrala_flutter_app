import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helper.dart';
import '../providers/ItemsProvider.dart';

import 'CompareStoreCard.dart';
import 'ShimmerePlaceHolder.dart';

class ItemCompareListComponent extends StatefulWidget {
  final String sku;

  const ItemCompareListComponent({super.key, required this.sku});

  @override
  State<ItemCompareListComponent> createState() =>
      _ItemCompareListComponentState();
}

class _ItemCompareListComponentState extends State<ItemCompareListComponent> {
  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  @override
  void didUpdateWidget(covariant ItemCompareListComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sku != widget.sku) {
      _loadItems();
    }
  }

  void _loadItems() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ItemsProvider>().getItemsCompareBySKU(widget.sku);
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = 'items_compare_${widget.sku}';
    // El brillo efectivo del tema (System, Dark o Light)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark
          ? const Color.fromARGB(238, 16, 16, 16)
          : Color.fromARGB(255, 216, 230, 237),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Consumer<ItemsProvider>(
          builder: (context, provider, child) {
            final items = provider.getItems(key);
            final loading = provider.isLoading(key);

            String statusMessage;
            Widget content;

            if (loading && items.isEmpty) {
              statusMessage = 'Buscando ofertas...';

              content = SizedBox(
                width: double.infinity,
                height: 4,
              ); //BannerPlaceholder();
            } else if (items.isEmpty) {
              statusMessage = 'No hay ofertas para este producto..';

              content = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [BannerPlaceholder()],
              );
            } else {
              final totalItems = items.length;

              statusMessage = totalItems == 1
                  ? 'Disponible en 1 negocio'
                  : 'Disponible en $totalItems negocios';

              content = SizedBox(
                height: items.length * 80,
                child: ListView.builder(
                  shrinkWrap: false,
                  physics: NeverScrollableScrollPhysics(),

                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AnimatedSlide(
                      offset: Offset(0, 0),
                      duration: Duration(microseconds: 600),
                      child: CompareStoreCard(
                        name: item.NegocioNombre,
                        image: Helper.getLogoById(item.NegocioID),
                        bestPrice: index == 0,
                        price: item.PrecioNuevo.toDouble(),
                        discount: item.PrecioOff,
                        difference: 0,
                        link: item.Link,
                      ),
                    );
                  },
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                content,

                SizedBox(height: 2),
                //content,
              ],
            );
          },
        ),
      ),
    );
  }
}
