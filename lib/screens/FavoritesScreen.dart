import 'package:ahorrala/components/MenuNeoGlassNaviogator.dart';
import 'package:ahorrala/providers/CategoriesProvider.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:flutter/material.dart';
import 'package:ahorrala/helpers/Helper.dart';

import 'package:ahorrala/components/FavoriteItemShimmer.dart';
import 'package:ahorrala/components/ProductItemList.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import '../providers/FavoritesProvider.dart';
import '../providers/ItemsProvider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, required String title});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  static const String _favoritesKey = 'items_favorites';
  ScrollController _scrollController = ScrollController();
  bool showBottom = true;

  // late AuthProvider authProvider;

  late ItemsProvider itemsProvider;

  late ConfigProvider configProvider;

  late FavoritesProvider favoritesProvider;

  late int itemsLimit;

  late bool forceRefresh = false;

  late CategoriesProvider categoriesProvider;
  @override
  void initState() {
    super.initState();

    _loadScrollerCotroler();
    Future.microtask(_loadProviders);
  }

  Future<void> _loadProviders({bool forceRefresh = false}) async {
    //final authProvider = context.read<AuthProvider>();

    final favoritesProvider = context.read<FavoritesProvider>();

    final itemsProvider = context.read<ItemsProvider>();

    await itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,
      forceRefresh: forceRefresh,
    );
  }

  void _loadScrollerCotroler() {
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showBottom) {
          setState(() => showBottom = false);
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showBottom) {
          setState(() => showBottom = true);
        }
      }
    });
  }

  void _loadProviders2() {
    //  authProvider = context.read<AuthProvider>();
    itemsProvider = context.read<ItemsProvider>();
    configProvider = context.read<ConfigProvider>();
    favoritesProvider = context.read<FavoritesProvider>();
    categoriesProvider = context.read<CategoriesProvider>();
    configProvider.load();
    setState(() {
      showBottom = configProvider.autoHideBottomBar;
      itemsLimit = configProvider.itemsResultsTotal;
    });

    itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,
      forceRefresh: forceRefresh,
    );
    categoriesProvider.loadCategories();

    itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,
      forceRefresh: false,
    );
    Helper.obtenerDatosControl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: const Text('Mis Favoritos')),

      body: Consumer<ItemsProvider>(
        builder: (context, itemsProvider, child) {
          final items = itemsProvider.getItemsFavorites();

          final loading = itemsProvider.isLoading(_favoritesKey);

          if (loading) {
            return ListView.builder(
              controller: _scrollController,

              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) {
                return FavoriteItemShimmer();
              },
            );
          }

          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 80),
                  SizedBox(height: 15),
                  Text('No tienes favoritos'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return _loadProviders(forceRefresh: false);
            },
            child: CustomScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      items.length == 1
                          ? '1 producto favorito'
                          : '${items.length} productos favoritos',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 11),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = items[index];

                    return ProductItemList(
                      sku: item.Sku,
                      size: 1,
                      image: item.Imagen,
                      title: item.Titulo,
                      price: item.PrecioNuevo.toDouble(),
                      onFavoritePressed: () async {
                        await Future.delayed(const Duration(milliseconds: 100));

                        if (!mounted) {
                          return;
                        }

                        // await _loadFavorites(forceRefresh: false);
                      },
                      onTap: () {
                        String friendlyTitle = Helper.sanitizeToFriendlyUrl(
                          item.Titulo,
                        );
                        context.go(
                          '/items/${item.Sku}/$friendlyTitle',
                          extra: item,
                        );
                      },
                      category: item.CategoriaNombre,
                      category_id: item.CategoriaID,
                    );
                  }, childCount: items.length),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: context.read<ConfigProvider>().autoHideBottomBar
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: showBottom ? Offset.zero : const Offset(0, 2),
              child: MenuNeoGlassNavigationBar(selectedItem: 3),
            )
          : MenuNeoGlassNavigationBar(selectedItem: 3),
    );
  }
}
