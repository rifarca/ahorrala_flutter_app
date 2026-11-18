import 'package:ahorrala/helpers/Helper.dart';
import 'package:ahorrala/providers/AuthProvider.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:flutter/rendering.dart';

import '../components/CategoryItemGrid.dart';
import '../components/ShimmerePlaceHolder.dart';
import '../components/ShimmerProductItemGrid.dart';
import '../models/Categories.dart';
import '../providers/CategoriesProvider.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ahorrala/components/MenuCrystalBottomNavigationBar.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.title});

  final String title;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  ScrollController _scrollController = ScrollController();
  bool showBottom = true;

  late AuthProvider authProvider;

  late ItemsProvider itemsProvider;

  late ConfigProvider configProvider;

  late FavoritesProvider favoritesProvider;

  late int itemsLimit;

  late bool forceRefresh = false;

  late CategoriesProvider categoriesProvider;
  @override
  void initState() {
    super.initState();

    Future.microtask(() => _loadProviders());
    _loadScrollerCotroler();
    
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
    configProvider = context.read<ConfigProvider>();
    favoritesProvider = context.read<FavoritesProvider>();

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

  Future<void> _loadProviders({bool forceRefresh = false}) async {
    final categoriesProvide = context.read<CategoriesProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();

    final itemsProvider = context.read<ItemsProvider>();

    await itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,
      forceRefresh: forceRefresh,
    );
    categoriesProvide.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    int grids = 2;

    if (kIsWeb) {
      grids = 4;
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text(widget.title)),

      body: Consumer<CategoriesProvider>(
        builder: (context, provider, child) {
          // Primera carga sin cache
          if (provider.categories.isEmpty && provider.loading) {
            return GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: grids,

                crossAxisSpacing: 2,

                mainAxisSpacing: 2,
              ),

              padding: const EdgeInsets.all(8),

              itemCount: 12,

              itemBuilder: (context, index) {
                return ShimmerProductItemGrid(
                  width: 180,

                  height: 160,

                  borderRadius: 16,
                );
              },
            );
          }

          // Sin datos
          if (provider.categories.isEmpty) {
            return Column(
              children: [
                BannerPlaceholder(),

                BannerPlaceholder(),

                BannerPlaceholder(),
              ],
            );
          }

          // Datos desde Hive o API

          return Padding(
            padding: const EdgeInsets.all(16),

            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: grids,

                crossAxisSpacing: 1,

                mainAxisSpacing: 2,
              ),

              itemCount: provider.categories.length,

              itemBuilder: (context, index) {
                final category = provider.categories[index];

                return CategoryitemGrid(
                  categoria_id: category.id,

                  categoria: category.name,

                  imagen: category.image,

                  onTap: () {
                    final cat = Categories(
                      id: category.id,

                      name: category.name,

                      image: category.image,

                      items: category.items,

                      subs: category.subs,
                    );

                    context.push("/categorias/${category.id}", extra: cat);
                  },
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: context.read<ConfigProvider>().autoHideBottomBar
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: showBottom ? Offset.zero : const Offset(0, 2),
              child: MenuCrystalBottomNavigationBar(selectedItem: 1),
            )
          : MenuCrystalBottomNavigationBar(selectedItem: 1),
    );
  }
}
