import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../helpers/helper.dart';
import '../models/Items.dart';
import '../providers/ItemsProvider.dart';

import 'ProductItemGrid.dart';
import 'ShimmerProductItemGrid.dart';

class ItemsByCategoryListComponent extends StatefulWidget {
  final int cat;
  final int sub;
  final int limit;

  const ItemsByCategoryListComponent({
    super.key,
    required this.cat,
    this.sub = 1,
    this.limit = 16,
  });

  @override
  State<ItemsByCategoryListComponent> createState() =>
      _ItemsByCategoryListComponentState();
}

class _ItemsByCategoryListComponentState
    extends State<ItemsByCategoryListComponent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ItemsProvider>().getItemsByCategory(widget.cat);
    });
  }

  @override
  void didUpdateWidget(covariant ItemsByCategoryListComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cat != widget.cat ||
        oldWidget.sub != widget.sub ||
        oldWidget.limit != widget.limit) {
      _loadItems();
    }
  }

  void _loadItems() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ItemsProvider>().getItemsByCategory(widget.cat);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = Helper.getCategoryNameById(widget.cat);

    final categoryImage = Helper.getCategoryImageById(widget.cat);

    final category = Helper.getCategoryByID(widget.cat);

    return Consumer<ItemsProvider>(
      builder: (context, provider, child) {
        final items = provider.getItems("items_cat_${widget.cat}");

        final loading = provider.isLoading("items_cat_${widget.cat}");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    categoryImage,
                    width: 46,
                    height: 36,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      categoryName,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      context.push(
                        "/categorias/${widget.cat}",
                        extra: category,
                      );
                    },
                    child: const Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 260,
              child: loading
                  ? _buildShimmer()
                  : items.isEmpty
                  ? const Center(child: Text("No hay datos"))
                  : _buildItems(items),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemBuilder: (_, index) {
        return const Padding(
          padding: EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 175,
            height: 260,
            child: ShimmerProductItemGrid(width: 175, height: 260),
          ),
        );
      },
    );
  }

  Widget _buildItems(List<Items> items) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 175,
            height: 260,
            child: ProductItemGrid(
              size: 1,
              image: item.Imagen,
              title: item.Titulo,
              price: item.PrecioNuevo.toDouble(),
              sku: item.Sku,
              onTap: () {
                final friendlyTitle = Helper.sanitizeToFriendlyUrl(item.Titulo);

                context.push('/items/${item.Sku}/$friendlyTitle', extra: item);
              },
            ),
          ),
        );
      },
    );
  }
}
