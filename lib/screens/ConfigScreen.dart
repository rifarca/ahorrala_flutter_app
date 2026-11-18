import 'package:ahorrala/helpers/Helper.dart';
import 'package:ahorrala/providers/CategoriesProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:ahorrala/components/MenuCrystalBottomNavigationBar.dart';
import '../providers/ConfigProvider.dart';

class ConfigScreen extends StatefulWidget {
  final String title;

  const ConfigScreen({super.key, required this.title});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final ScrollController _scrollController = ScrollController();

  bool showBottom = true;
  bool forceRefresh = false;

  late ItemsProvider itemsProvider;
  late ConfigProvider configProvider;
  late FavoritesProvider favoritesProvider;
  late CategoriesProvider categoriesProvider;

  int itemsLimit = 24;

  @override
  void initState() {
    super.initState();

    _loadScrollerController();

    Future.microtask(_loadProviders);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadScrollerController() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) {
        return;
      }

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

    if (!mounted) return;

    setState(() {
      showBottom = configProvider.autoHideBottomBar;

      itemsLimit = configProvider.itemsResultsTotal;
    });

    await itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,
      forceRefresh: forceRefresh,
    );

    await categoriesProvider.loadCategories();

    Helper.obtenerDatosControl();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigProvider>(
      builder: (context, config, child) {
        return Scaffold(
          extendBody: true,

          appBar: AppBar(title: Text(widget.title)),

          body: Padding(
            padding: const EdgeInsets.all(16),

            child: ListView(
              controller: _scrollController,

              children: [
                _sectionTitle(context, "APARIENCIA"),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.palette_outlined),

                    title: const Text("Tema"),

                    subtitle: Text(_themeName(config.themeMode)),

                    trailing: const Icon(Icons.chevron_right),

                    onTap: () => _showThemeSelector(context, config),
                  ),
                ),

                Card(
                  child: SwitchListTile(
                    secondary: const Icon(Icons.menu),

                    title: const Text("Auto ocultar menú inferior"),

                    subtitle: const Text("Oculta el menú al hacer scroll"),

                    value: config.autoHideBottomBar,

                    onChanged: config.setAutoHideBottomBar,
                  ),
                ),

                const Divider(),

                _sectionTitle(context, "PRODUCTOS"),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),

                    title: const Text("Resultados por consulta"),

                    subtitle: Text("${config.itemsResultsTotal} productos"),

                    trailing: DropdownButton<int>(
                      value: config.itemsResultsTotal,

                      underline: const SizedBox(),

                      items: [
                        DropdownMenuItem(value: 12, child: Text("12")),

                        DropdownMenuItem(value: 16, child: Text("16")),
                        DropdownMenuItem(value: 20, child: Text("20")),
                        DropdownMenuItem(value: 30, child: Text("30")),

                        DropdownMenuItem(value: 40, child: Text("40")),

                        DropdownMenuItem(value: 50, child: Text("50")),
                      ],

                      onChanged: (value) {
                        if (value != null) {
                          config.setItemsResultsTotal(value);
                        }
                      },
                    ),
                  ),
                ),

                Card(
                  child: SwitchListTile(
                    secondary: const Icon(Icons.shuffle),

                    title: const Text("Productos aleatorios"),

                    subtitle: const Text(
                      "Mostrar productos en orden aleatorio",
                    ),

                    value: config.itemsRandom,

                    onChanged: config.setItemsRandom,
                  ),
                ),

                const Divider(),

                _sectionTitle(context, "CACHÉ"),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.cached),

                        title: const Text("Duración del caché"),

                        subtitle: Text(
                          "${config.cacheItemsExpireMinutes} minutos",
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),

                        child: Slider(
                          min: 5,

                          max: 120,

                          divisions: 23,

                          value: config.cacheItemsExpireMinutes
                              .clamp(5, 120)
                              .toDouble(),

                          label: "${config.cacheItemsExpireMinutes} min",

                          onChanged: (value) {
                            config.setCacheItemsExpireMinutes(value.round());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: config.autoHideBottomBar
              ? AnimatedSlide(
                  duration: const Duration(milliseconds: 250),

                  offset: showBottom ? Offset.zero : const Offset(0, 2),

                  child: MenuCrystalBottomNavigationBar(selectedItem: 4),
                )
              : MenuCrystalBottomNavigationBar(selectedItem: 4),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),

      child: Text(
        title,

        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,

          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "Claro";

      case ThemeMode.dark:
        return "Oscuro";

      case ThemeMode.system:
        return "Sistema";
    }
  }

  void _showThemeSelector(BuildContext context, ConfigProvider config) {
    showModalBottomSheet(
      context: context,

      showDragHandle: true,

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const ListTile(
                title: Text(
                  "Seleccionar tema",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              RadioListTile<ThemeMode>(
                title: const Text("Sistema"),

                value: ThemeMode.system,

                groupValue: config.themeMode,

                onChanged: (value) async {
                  if (value != null) {
                    await config.setTheme(value);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),

              RadioListTile<ThemeMode>(
                title: const Text("Claro"),

                value: ThemeMode.light,

                groupValue: config.themeMode,

                onChanged: (value) async {
                  if (value != null) {
                    await config.setTheme(value);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),

              RadioListTile<ThemeMode>(
                title: const Text("Oscuro"),

                value: ThemeMode.dark,

                groupValue: config.themeMode,

                onChanged: (value) async {
                  if (value != null) {
                    await config.setTheme(value);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
