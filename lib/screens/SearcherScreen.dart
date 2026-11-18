// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahorrala/components/MenuCrystalBottomNavigationBar.dart';
import 'package:ahorrala/components/ProductItemList.dart';
import 'package:ahorrala/components/ShimmerePlaceHolder.dart';

import 'package:ahorrala/helpers/helper.dart';
import 'package:ahorrala/models/Items.dart';

import 'package:ahorrala/providers/CategoriesProvider.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';

enum OrderType { priceLow, priceHigh, titleAsc, titleDesc }

class SearchFilter {
  int categoryId;
  OrderType order;

  SearchFilter({this.categoryId = 0, this.order = OrderType.priceLow});
}

final categories = const [
  (0, "Todas"),
  (5, "Bebés"),
  (3, "Higiene"),
  (6, "Hogar"),
  (2, "Medicamentos"),
  (7, "Dermocosmética"),
  (4, "Perfumes"),
  (10, "Vitaminas"),
  (1, "Varios"),
];

class SearcherScreen extends StatefulWidget {
  const SearcherScreen({super.key});

  @override
  State<SearcherScreen> createState() => _SearcherScreenState();
}

class _SearcherScreenState extends State<SearcherScreen> {
  int categoria_id = 0;
  final SearchFilter _filter = SearchFilter();
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = "";

  Future<List<Items>>? _searchFuture;

  bool showBottom = true;

  late ItemsProvider itemsProvider;

  late ConfigProvider configProvider;

  late FavoritesProvider favoritesProvider;

  late CategoriesProvider categoriesProvider;

  int itemsLimit = 24;

  bool forceRefresh = false;

  List<String> _searchHistory = [];

  late int categorySearch;
  late int totalResult = 0;
  @override
  void initState() {
    super.initState();
    _loadProviders();
    _loadSearchHistory();
    _initScroll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showBottom) {
          setState(() {
            showBottom = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showBottom) {
          setState(() {
            showBottom = true;
          });
        }
      }
    });
  }

  Future<void> _loadProviders() async {
    itemsProvider = context.read<ItemsProvider>();

    configProvider = context.read<ConfigProvider>();

    favoritesProvider = context.read<FavoritesProvider>();

    categoriesProvider = context.read<CategoriesProvider>();

    await configProvider.load();

    showBottom = configProvider.autoHideBottomBar;

    itemsLimit = configProvider.itemsResultsTotal;

    await itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,

      forceRefresh: forceRefresh,
    );

    await categoriesProvider.loadCategories();

    Helper.obtenerDatosControl();
  }

  void _onSearchChanged(String value) {
    final query = value.trim();
    var key = context.read<ItemsProvider>().searchKey(query);
    var field_order = _orderToString(_filter.order).split(" ");
    var field = field_order[0];
    print("field: $field");
    var order = field_order[1];
    print("order: $order");
    context.read<ItemsProvider>().searchItems(
      query: query,
      field: field,
      order: order,
    );

    setState(() {
      // _searchFuture =  context.read<ItemsProvider>().getItemsBySearch(query)
      _searchQuery = query;

      /*if (query.length >= 3) {
        _searchFuture = Helper.getItemsBuscar(
          query: query,

          cat: _filter.categoryId,

          limit: context.read<ItemsProvider>().itemsTotalResult,

          field: _field,

          order: _order,
        );
      } else {
        _searchFuture = null;
      }*/
    });
  }

  String _orderToString(OrderType type) {
    switch (type) {
      case OrderType.priceLow:
        return "price_now ASC";

      case OrderType.priceHigh:
        return "price_now DESC";

      case OrderType.titleAsc:
        return "title ASC";

      case OrderType.titleDesc:
        return "title DESC";
    }
  }

  void _onSearchSubmitted(String value) {
    final query = value.trim();

    if (query.length >= 3) {
      _saveSearchHistory(query);

      _onSearchChanged(query);
    }
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _searchHistory = prefs.getStringList("search_history") ?? [];
    });
  }

  Future<void> _saveSearchHistory(String value) async {
    value = value.trim();

    if (value.length < 3) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    _searchHistory.remove(value);

    _searchHistory.insert(0, value);

    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await prefs.setStringList("search_history", _searchHistory);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _removeFromHistory(String value) async {
    _searchHistory.remove(value);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList("search_history", _searchHistory);

    if (mounted) {
      setState(() {});
    }
  }

  void _submitSearch(String value) {
    _searchController.text = value;

    _onSearchChanged(value);
  }

  Future<void> _showFilter() async {
    int category = _filter.categoryId;
    OrderType order = _filter.order;

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filtros",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Categoría",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<int>(
                    initialValue: category,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: categories.map((e) {
                      return DropdownMenuItem(value: e.$1, child: Text(e.$2));
                    }).toList(),
                    onChanged: (v) {
                      setModalState(() {
                        categorySearch = v!;
                        category = v;
                      });
                      _onSearchSubmitted(_searchQuery);
                    },
                  ),

                  const SizedBox(height: 28),

                  Text(
                    "Ordenar",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  RadioListTile<OrderType>(
                    value: OrderType.priceLow,
                    groupValue: order,
                    title: const Text("Precio más barato"),
                    subtitle: const Text("De Menor a Mayor"),
                    secondary: const Icon(Icons.arrow_downward),

                    onChanged: (v) {
                      setModalState(() {
                        order = v!;
                      });
                      _onSearchSubmitted(_searchQuery);
                    },
                  ),

                  RadioListTile<OrderType>(
                    value: OrderType.priceHigh,
                    groupValue: order,
                    title: const Text("Precio más caro"),
                    subtitle: const Text("Mayor → Menor"),
                    secondary: const Icon(Icons.arrow_upward),
                    onChanged: (v) {
                      setModalState(() {
                        order = v!;
                      });
                    },
                  ),

                  RadioListTile<OrderType>(
                    value: OrderType.titleAsc,
                    groupValue: order,
                    title: const Text("Título A-Z"),
                    secondary: const Icon(Icons.sort_by_alpha),
                    onChanged: (v) {
                      setModalState(() {
                        order = v!;
                      });
                    },
                  ),

                  RadioListTile<OrderType>(
                    value: OrderType.titleDesc,
                    groupValue: order,
                    title: const Text("Título Z-A"),
                    secondary: const Icon(Icons.sort_by_alpha),
                    onChanged: (v) {
                      setModalState(() {
                        order = v!;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.restart_alt),
                          label: const Text("Limpiar"),
                          onPressed: () {
                            setModalState(() {
                              category = 0;
                              order = OrderType.priceLow;
                            });

                            //  Navigator.pop(context);
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text("Aplicar"),
                          onPressed: () {
                            setModalState(() {
                              _filter.categoryId = category;
                              _filter.order = order;
                            });
                            _onSearchSubmitted(_searchQuery);
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }

                            // cargar búsqueda
                            //_search();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFiltersAction() {
    return // Botones inferiores
    Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              // Abrir filtros
              _showFilter();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white, // color del texto e iconos
            ),
            icon: const Icon(Icons.tune),
            label: const Text("Filtros"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: FilledButton.icon(
            onPressed: () async {
              final item = await context.push<Items>("/scanner");
              if (item == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No se encontró el producto")),
                );
                return;
              } else {
                context.push('/items/${item.Sku.toString()}', extra: item);
              }
            },

            // Escanear código de barras
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text("Escanear"),
          ),
        ),
      ],
    );
  }

  Widget _searchTextField() {
    return TextField(
      controller: _searchController,

      focusNode: _searchFocusNode,

      onChanged: _onSearchChanged,

      onSubmitted: _onSearchSubmitted,

      textInputAction: TextInputAction.search,

      decoration: const InputDecoration(
        hintText: "Buscar productos...",

        prefixIcon: Icon(Icons.search),

        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPlaceholderList(int count) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),

      itemCount: count,

      separatorBuilder: (_, index) => const SizedBox(height: 8),

      itemBuilder: (context, index) {
        return const SearchResultPlaceholder();
      },
    );
  }

  Widget _buildHistoryView() {
    if (_searchHistory.isEmpty) {
      return const Center(
        child: Text(
          "Escribe para buscar productos",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,

      itemCount: _searchHistory.length,

      itemBuilder: (context, index) {
        final history = _searchHistory[index];

        return ListTile(
          leading: const Icon(Icons.history),

          title: Text(history),

          trailing: IconButton(
            icon: const Icon(Icons.close),

            onPressed: () => _removeFromHistory(history),
          ),

          onTap: () => _submitSearch(history),
        );
      },
    );
  }

  //carga el resultado
  Widget _buildSearchResults() {
    return Consumer<ItemsProvider>(
      builder: (context, provider, child) {
        final key = provider.searchKey(_searchQuery);
        // Estado de carga
        if (provider.isLoading(key)) {
          return _buildPlaceholderList(6);
        }

        // Resultados
        List<Items> items = provider.getItemsBySearch(_searchQuery);

        // Ordenar localmente (opcional)
        switch (_filter.order) {
          case OrderType.priceLow:
            items.sort((a, b) => a.PrecioNuevo.compareTo(b.PrecioNuevo));
            break;

          case OrderType.priceHigh:
            items.sort((a, b) => b.PrecioNuevo.compareTo(a.PrecioNuevo));
            break;

          case OrderType.titleAsc:
            items.sort((a, b) => a.Titulo.compareTo(b.Titulo));
            break;

          case OrderType.titleDesc:
            items.sort((a, b) => b.Titulo.compareTo(a.Titulo));
            break;
        }

        // Total de resultados
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && totalResult != items.length) {
            setState(() {
              totalResult = items.length;
            });
          }
        });

        if (items.isEmpty) {
          return const Center(child: Text("No se encontraron productos"));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final currentItem = items[index];

            return ProductItemList(
              sku: currentItem.Sku,
              size: kIsWeb ? 4 : 3,
              image: currentItem.Imagen,
              title: currentItem.Titulo,
              category_id: currentItem.CategoriaID,
              category: currentItem.CategoriaNombre,
              price: currentItem.PrecioNuevo.toDouble(),
              onTap: () {
                final title = Helper.sanitizeToFriendlyUrl(currentItem.Titulo);

                context.push(
                  "/items/${currentItem.Sku}/$title",
                  extra: currentItem,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResultsOLD() {
    if (_searchFuture == null) {
      return _buildHistoryView();
    }

    return FutureBuilder<List<Items>>(
      future: _searchFuture,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholderList(6);
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final items = snapshot.data ?? [];
        if (_filter.order.index == OrderType.priceLow) {
          items.sort((a, b) => a.PrecioNuevo.compareTo(b.PrecioNuevo));
        }

        if (_filter.order.index == OrderType.priceHigh) {
          items.sort((a, b) => b.PrecioNuevo.compareTo(a.PrecioNuevo));
        }
        if (_filter.order.index == OrderType.titleAsc) {
          items.sort((a, b) => a.Titulo.compareTo(b.Titulo));
        }

        if (_filter.order.index == OrderType.titleDesc) {
          items.sort((a, b) => b.Titulo.compareTo(a.Titulo));
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && totalResult != items.length) {
            setState(() {
              totalResult = items.length;
            });
          }
        });
        if (items.isEmpty) {
          return const Center(child: Text("No se encontraron productos"));
        }

        return ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,

          itemCount: items.length,

          itemBuilder: (context, index) {
            final currentItem = items[index];

            return ProductItemList(
              sku: currentItem.Sku,

              size: kIsWeb ? 4 : 3,

              image: currentItem.Imagen,

              title: currentItem.Titulo,

              category_id: currentItem.CategoriaID,

              category: currentItem.CategoriaNombre,

              price: currentItem.PrecioNuevo.toDouble(),

              onTap: () {
                final title = Helper.sanitizeToFriendlyUrl(currentItem.Titulo);

                context.push(
                  "/items/${currentItem.Sku}/$title",

                  extra: currentItem,
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      appBar: AppBar(
        title: Text("Buscador"),

        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _searchTextField(),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildFiltersAction(),
          ),
          _showResultTotal(),
          Expanded(
            child: _searchQuery.length >= 3
                ? Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 7),
                    child: _buildSearchResults(),
                  )
                : _buildHistoryView(),
          ),
        ],
      ),

      bottomNavigationBar: configProvider.autoHideBottomBar
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 250),

              offset: showBottom ? Offset.zero : const Offset(0, 2),

              child: MenuCrystalBottomNavigationBar(selectedItem: 2),
            )
          : MenuCrystalBottomNavigationBar(selectedItem: 2),
    );
  }

  Widget _showResultTotal() {
    final total = totalResult;
    late String msg = "";
    if (total == 0) {
      msg = "";
    } else if (total == 1) {
      msg = "$total resultado de la busqueda ";
    } else {
      msg = "$total resultados de la busqueda ";
    }
    return Text(msg);
  }
}
