import 'package:ahorrala/components/MenuCrystalBottomNavigationBar.dart';
import 'package:ahorrala/components/ProductItemList.dart';
import 'package:ahorrala/components/ShimmerePlaceHolder.dart';
import 'package:ahorrala/helpers/Helper.dart';
import 'package:ahorrala/providers/AuthProvider.dart';
import 'package:ahorrala/providers/CategoriesProvider.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Items.dart';

enum OrderType { priceLow, priceHigh, titleAsc, titleDesc }

class SearchFilter {
  int categoryId;
  OrderType order;

  SearchFilter({this.categoryId = 0, this.order = OrderType.priceLow});
}

final categories = const [
  (0, "Todas"),
  (5, "Bebés"),
  (4, "Higiene"),
  (3, "Hogar"),
  (2, "Medicamentos"),
  (7, "Dermocosmética"),
  (6, "Perfumes"),
  (8, "Vitaminas"),
  (1, "Varios"),
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FavoritesProvider favoritesProvider;
  final SearchFilter _filter = SearchFilter();
  late ItemsProvider itemsProvider;

  late ConfigProvider configProvider;

  late bool showBottom;

  var _scrollController;
  late SearchController _searchController;
  late int itemsLimit;
  int categorySearch = 0;
  String fieldSearch = "title";
  String orderSaerch = "ASC";
  int cacheItemsExpireMinutes = 2;

  late List<String> _searchHistory;

  Future<List<Items>>? _searchFuture;

  late AuthProvider authProvider;

  late bool forceRefresh = false;

  late CategoriesProvider categoriesProvider;

  late String _searchQuery;

  final bool _searchBoolean = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    showBottom = true;
    itemsLimit = 24;

    _loadScrollerControler();

    Future.microtask(() {
      _loadProviders();
      _loadSearchHistory();
    });
  }

  Future<void> _loadSearchHistory() async {
    _searchController = SearchController();
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
    Future<void> saveSearch(String value) async {
      if (value.trim().isEmpty) return;

      final text = value.trim().toLowerCase();

      final prefs = await SharedPreferences.getInstance();

      _searchHistory.remove(text);

      _searchHistory.insert(0, text);

      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.sublist(0, 10);
      }

      await prefs.setStringList('search_history', _searchHistory);

      // Guardamos key separada para búsquedas rápidas

      final keys = prefs.getStringList('search_keys') ?? [];

      if (!keys.contains(text)) {
        keys.add(text);
      }

      await prefs.setStringList('search_keys', keys);

      setState(() {});
    }
  }

  void _loadScrollerControler() {
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

  void _clearSearch() {
    _searchController.clear();

    setState(() {});
  }

  // Eliminamos los "await" incorrectos sobre context.read (que no devuelve un Future)
  Future<void> _loadProviders() async {
    itemsProvider = context.read<ItemsProvider>();
    configProvider = context.read<ConfigProvider>();
    favoritesProvider = context.read<FavoritesProvider>();

    await configProvider.load();

    // Corrección: Usar setState si alteras propiedades de la clase que impactan la UI
    final autoHide = configProvider.autoHideBottomBar;
    final totalResults = configProvider.itemsResultsTotal;

    setState(() {
      showBottom = autoHide;
      itemsLimit = totalResults;
    });

    Helper.obtenerDatosControl();
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        Text(
          "Búsquedas recientes",
          style: Theme.of(context).textTheme.titleMedium,
        ),

        Wrap(
          spacing: 8,
          children: _searchHistory.map((e) {
            return ActionChip(
              avatar: const Icon(Icons.history, size: 18),

              label: Text(e),

              onPressed: () {
                _searchController.text = e;
                ();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscador", style: TextStyle())),
      bottomNavigationBar: MenuCrystalBottomNavigationBar(selectedItem: 2),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: !_searchBoolean
                ? _buildSearchComponent()
                : _searchListView(),
            //88_buildSearchComponent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchComponent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      //margin:
      //const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caja de búsqueda
          /*  SearchBar(
            controller: _searchController,
            onSubmitted: _onSearchChanged,
          ),*/
          TextField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar productos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  // Limpiar búsqueda
                },
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              /* border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),*/
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onSubmitted: (value) {
              // Buscar
              _submitSearch(value);
            },
          ),

          const SizedBox(height: 12),

          // Botones inferiores
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
                  onPressed: () {
                    // Escanear código de barras
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Escanear"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Guarda un término nuevo en el historial (evitando duplicados)
  Future<void> _saveToHistory(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    // Quitamos si ya existe para moverlo al principio de la lista
    _searchHistory.remove(query.trim());
    _searchHistory.insert(0, query.trim());

    // Limitamos el historial a las últimas 10 búsquedas
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await prefs.setStringList('search_history', _searchHistory);
    setState(() {});
  }

  // Elimina un término específico del historial
  Future<void> _removeFromHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory.remove(query);
    await prefs.setStringList('search_history', _searchHistory);
    setState(() {});
  }

  // Maneja la escritura del usuario (Sugerencias en tiempo real)
  void _onSearchChanged(String text) {
    setState(() {
      _searchQuery = text;
      if (text.trim().length > 2) {
        var fieldOrder = _orderToString(_filter.order).split(" ");
        var field = fieldOrder[0];
        var order =
            fieldOrder[1]; // Petición al servidor mientras escribe (actúa como sugerencia/autocompletado)
        _searchFuture = Helper.getItemsBuscar(
          query: text.trim(),
          cat: 0,
          limit: context.read<ConfigProvider>().itemsResultsTotal,
          field: field,
          order: order,
        );
      } else {
        _searchFuture = null;
      }
    });
  }

  // Ejecuta la búsqueda final y guarda en el historial
  void _submitSearch(String text) {
    if (text.trim().length > 2) {
      _saveToHistory(text.trim());
      _onSearchChanged(text);
    }
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
            return SafeArea(
              child: Padding(
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
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: FilledButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text("Aplicar"),
                            onPressed: () {
                              setState(() {
                                _filter.categoryId = category;
                                _filter.order = order;
                              });

                              Navigator.pop(context);

                              // cargar búsqueda
                              //_search();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Muestra los resultados filtrados o el historial/sugerencias estáticas
  Widget _buildPlaceholderList(int count) {
    return ListView.separated(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 8.0),
      itemBuilder: (_, _) => const SearchResultPlaceholder(),
    );
  }

  Widget _searchListView() {
    // Si no hay texto suficiente, renderizamos la vista de HISTORIAL
    if (_searchQuery.trim().length <= 2 || _searchFuture == null) {
      return _buildHistoryView();
    }

    final grids = kIsWeb ? 4 : 3;

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

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final currentItem = items[index];
                return ProductItemList(
                  sku: currentItem.Sku,
                  size: grids,
                  image: currentItem.Imagen,
                  title: currentItem.Titulo,
                  price: currentItem.PrecioNuevo.toDouble(),
                  onTap: () {
                    // Guardamos en el historial al hacer clic en un producto comercial
                    _saveToHistory(_searchController.text);

                    Items item = Items(
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

                    String titleUrl = Helper.sanitizeToFriendlyUrl(
                      currentItem.Titulo,
                    );
                    context.push(
                      '/items/${currentItem.Sku}/$titleUrl',
                      extra: item,
                    );
                  },
                  category: currentItem.CategoriaNombre,
                  category_id: currentItem.CategoriaID,
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Componente visual para la lista de búsquedas anteriores
  Widget _buildHistoryView() {
    if (_searchHistory.isEmpty) {
      return const Center(
        child: Text(
          'Escribe al menos 3 caracteres para buscar',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchHistory.length + 1,
      itemBuilder: (context, index) {
        // Fila de encabezado para el historial
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Búsquedas recientes',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          );
        }

        final historyItem = _searchHistory[index - 1];
        return ListTile(
          leading: const Icon(Icons.history, color: Colors.grey),
          title: Text(historyItem),
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => _removeFromHistory(historyItem),
          ),
          onTap: () {
            // Al tocar un elemento del historial, se rellena el buscador y se ejecuta
            _searchController.text = historyItem;
            _submitSearch(historyItem);
          },
        );
      },
    );
  }

  Widget _defaultListView() {
    return const Center(child: Text('Pantalla principal de inicio'));
  }
}
