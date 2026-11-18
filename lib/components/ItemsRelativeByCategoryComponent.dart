import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../helpers/helper.dart';
import '../models/Items.dart';
import '../providers/ItemsProvider.dart';
import 'ProductItemGrid.dart';
import 'ShimmerProductItemGrid.dart';
import 'package:provider/provider.dart';

class ItemsRelativeByCategoryComponent extends StatefulWidget {
  final String sku;
  final int cat;
  final int limit;

  const ItemsRelativeByCategoryComponent({
    super.key,
    required this.sku,
    required this.cat,
    this.limit = 16,
  });

  @override
  State<ItemsRelativeByCategoryComponent> createState() =>
      _ItemsRelativeByCategoryComponentState();
}

class _ItemsRelativeByCategoryComponentState
    extends State<ItemsRelativeByCategoryComponent> {
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemsRelativeByCategoryComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sku != widget.sku) {
      _loadItems();
    }
  }

  void _loadItems() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = context.read<ItemsProvider>();

      provider.loadItemsRelativeByCategory(sku: widget.sku);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = Helper.getColorByCategoryId(widget.cat);

    return Consumer<ItemsProvider>(
      builder: (context, provider, child) {
        final key = provider.relativeCategoryKey(widget.sku);

        final items = provider.getItems(key);

        final loading = provider.isLoading(key);

        final finished = provider.isFinished(key);

        final total = provider.getTotalResult(key);

        debugPrint('RELATED UI ${widget.sku}: ${items.length}');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(categoryColor, total),

            SizedBox(
              height: 260,
              child: _buildContent(
                items: items,
                loading: loading,
                finished: finished,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent({
    required List<Items> items,
    required bool loading,
    required bool finished,
  }) {
    if (loading && items.isEmpty) {
      return _buildShimmer();
    }

    if (finished && items.isEmpty) {
      return _buildShimmer();
    }

    if (items.isEmpty) {
      return _buildShimmer();
    }

    return _buildItems(items);
  }

  Widget _buildHeader(Color categoryColor, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 8, bottom: 5),
          child: Row(
            children: [
              const Icon(CupertinoIcons.tag_solid, size: 26),

              Text(
                'Productos Relacionados',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              if (total > 0) ...[
                Text(
                  '($total)',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(height: 2, child: ColoredBox(color: categoryColor)),
        ),
      ],
    );
  }

  Widget _buildItems(List<Items> items) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 180,
            height: 260,
            child: ProductItemGrid(
              size: 1,
              image: item.Imagen,
              title: item.Titulo,
              price: item.PrecioNuevo.toDouble(),
              sku: item.Sku,
              onTap: () {
                final title = Helper.sanitizeToFriendlyUrl(item.Titulo);

                context.push('/items/${item.Sku}/$title', extra: item);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
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
}
