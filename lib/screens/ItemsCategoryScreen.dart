// ignore_for_file: non_constant_identifier_names

import 'package:ahorrala/components/MenuNeoGlassNaviogator.dart';
import 'package:flutter/material.dart';
import 'package:ahorrala/providers/CategoriesProvider.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';


import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../components/ProductItemList.dart';
import 'package:flutter/foundation.dart';

import 'package:go_router/go_router.dart';
import '../components/ShimmerePlaceHolder.dart';
import '../helpers/helper.dart';
import '../models/Items.dart';

class ItemsCategoryScreen extends StatefulWidget {
  final String categoria;
  final int categoria_id;
  final String imagen;

  const ItemsCategoryScreen({
    super.key,
    required this.categoria_id,
    required this.categoria,
    required this.imagen,
  });

  @override
  State<ItemsCategoryScreen> createState() => _ItemsCategoryScreenState();
}

class _ItemsCategoryScreenState extends State<ItemsCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";
  Future<List<Items>>? _searchFuture;
  final ScrollController _scrollController = ScrollController();
  bool showBottom = true;

  //  late AuthProvider authProvider;

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
    _loadProviders;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ItemsProvider>().getItemsByCategory(widget.categoria_id);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadScrollerCotroler() {
    //_scrollController = ScrollController();

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

  void _loadProviders() {
    // authProvider = context.read<AuthProvider>();
    itemsProvider = context.read<ItemsProvider>();
    configProvider = context.read<ConfigProvider>();
    favoritesProvider = context.read<FavoritesProvider>();
    categoriesProvider = context.read<CategoriesProvider>();
    configProvider.load();
    showBottom = configProvider.autoHideBottomBar;
    itemsLimit = configProvider.itemsResultsTotal;

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

  void _onSearchChanged(String value) {
    final query = value.trim();
    setState(() {
      _searchQuery = query;
      if (query.length > 2) {
        _searchFuture = Helper.getItemsBuscar(
          query: query,
          cat: widget.categoria_id,
          limit: 100,
          field: 'title',
          order: 'asc',
        );
      } else {
        _searchFuture = null;
      }
    });
  }

  void _onSearchSubmitted(String value) {
    final query = value.trim();
    if (query.length > 2) {
      _onSearchChanged(query);
    }
  }

  Widget _searchTextField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      onChanged: _onSearchChanged,
      onSubmitted: _onSearchSubmitted,
      cursorColor: const Color.fromARGB(255, 24, 24, 24),
      style: const TextStyle(
        color: Color.fromARGB(255, 10, 10, 10),
        fontSize: 15,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 102, 101, 101)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 102, 101, 101)),
        ),
        hintText: 'Buscar en esta categoría...',
        hintStyle: TextStyle(
          // color: Color.fromARGB(153, 10, 10, 10),
          fontSize: 15,
        ),
        prefixIcon: Icon(Icons.search, color: Color.fromARGB(153, 10, 10, 10)),
      ),
    );
  }

  Widget _buildCategoryBanner() {
    return widget.imagen.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                widget.imagen,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.photo, color: Colors.grey),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildPlaceholderList(int count) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 8.0),
      itemBuilder: (context, index) => const SearchResultPlaceholder(),
    );
  }

  Widget _buildSearchResults() {
    final grids = kIsWeb ? 4 : 3;

    if (_searchFuture == null) {
      return const Center(
        child: Text(
          'Escribe al menos 3 caracteres para buscar',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return FutureBuilder<List<Items>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholderList(4);
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error al buscar: ${snapshot.error}'));
        }

        final items = snapshot.data;

        if (items == null || items.isEmpty) {
          return const Center(child: Text('No hay resultados'));
        }

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final currentItem = items[index];
              return ProductItemList(
                sku: currentItem.Sku,
                size: grids,
                image: currentItem.Imagen,
                title: currentItem.Titulo,
                category_id: currentItem.CategoriaID,
                category: currentItem.CategoriaNombre,

                price: currentItem.PrecioNuevo.toDouble(),
                onTap: () {
                  final item = Items(
                    Sku: currentItem.Sku,
                    Titulo: currentItem.Titulo,
                    Imagen: currentItem.Imagen,
                    CategoriaID: currentItem.CategoriaID,
                    CategoriaNombre: currentItem.CategoriaNombre,
                    SubcategoriaNombre: currentItem.SubcategoriaNombre,
                    SubcategoriaID: currentItem.CategoriaID,
                    NegocioID: currentItem.NegocioID,
                    NegocioNombre: currentItem.NegocioNombre,
                    PrecioNuevo: currentItem.PrecioNuevo,
                    PrecioViejo: currentItem.PrecioViejo,
                    PrecioOff: currentItem.PrecioOff,
                    Link: currentItem.Link,
                  );
                  final title = Helper.sanitizeToFriendlyUrl(
                    currentItem.Titulo,
                  );
                  context.push('/items/${currentItem.Sku}/$title', extra: item);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryItemsOld() {
    final grids = kIsWeb ? 4 : 3;

    return FutureBuilder<List<Items>>(
      future: Helper.getItemsListByCategory(
        cat: widget.categoria_id,
        sub: 1,
        limit: 100,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholderList(6);
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar productos: ${snapshot.error}'),
          );
        }

        final items = snapshot.data;
        if (items == null || items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'No hay productos en esta categoría',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            itemCount: items.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final currentItem = items[index];
              return ProductItemList(
                sku: currentItem.Sku,
                size: grids,
                image: currentItem.Imagen,
                title: currentItem.Titulo,
                price: currentItem.PrecioNuevo.toDouble(),
                onTap: () {
                  final item = Items(
                    Sku: currentItem.Sku,
                    Titulo: currentItem.Titulo,
                    Imagen: currentItem.Imagen,
                    CategoriaID: currentItem.CategoriaID,
                    CategoriaNombre: currentItem.CategoriaNombre,
                    SubcategoriaNombre: currentItem.SubcategoriaNombre,
                    SubcategoriaID: currentItem.CategoriaID,
                    NegocioID: currentItem.NegocioID,
                    NegocioNombre: currentItem.NegocioNombre,
                    PrecioNuevo: currentItem.PrecioNuevo,
                    PrecioViejo: currentItem.PrecioViejo,
                    PrecioOff: currentItem.PrecioOff,
                    Link: currentItem.Link,
                  );
                  final title = Helper.sanitizeToFriendlyUrl(
                    currentItem.Titulo,
                  );
                  context.push('/items/${currentItem.Sku}/$title', extra: item);
                },
                category: currentItem.CategoriaNombre,
                category_id: currentItem.CategoriaID,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryItems() {
    final grids = kIsWeb ? 4 : 3;
    final key = 'items_cat_${widget.categoria_id}';

    return Consumer<ItemsProvider>(
      builder: (context, provider, child) {
        final items = provider.getItems(key);
        final loading = provider.isLoading(key);

        if (loading && items.isEmpty) {
          return _buildPlaceholderList(6);
        }

        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'No hay productos en esta categoría',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.vertical,

            itemCount: items.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final currentItem = items[index];

              return ProductItemList(
                sku: currentItem.Sku,
                size: grids,
                image: currentItem.Imagen,
                title: currentItem.Titulo,
                price: currentItem.PrecioNuevo.toDouble(),
                onTap: () {
                  final title = Helper.sanitizeToFriendlyUrl(
                    currentItem.Titulo,
                  );

                  context.push(
                    '/items/${currentItem.Sku}/$title',
                    extra: currentItem,
                  );
                },
                category: currentItem.CategoriaNombre,
                category_id: currentItem.CategoriaID,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(widget.categoria),
        //  backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildCategoryBanner(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: _searchTextField(),
          ),

          Expanded(
            child: _searchQuery.length > 2
                ? _buildSearchResults()
                : _buildCategoryItems(),
          ),
        ],
      ),
      bottomNavigationBar: context.read<ConfigProvider>().autoHideBottomBar
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: showBottom ? Offset.zero : const Offset(0, 2),
              child: MenuNeoGlassNavigationBar(selectedItem: 1),
            )
          : MenuNeoGlassNavigationBar(selectedItem: 1),
    );
  }
}
