import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_glass_navigation_bar/neo_glass_navigation_bar.dart';
import 'package:provider/provider.dart';

class MenuNeoGlassNavigationBar extends StatefulWidget {
  MenuNeoGlassNavigationBar({super.key, required this.selectedItem});

  int selectedItem;

  @override
  State<MenuNeoGlassNavigationBar> createState() =>
      _MenuNeoGlassNavigationBarState();
}

class _MenuNeoGlassNavigationBarState extends State<MenuNeoGlassNavigationBar> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_loadProviders);
  }

  Future<void> _loadProviders({bool forceRefresh = false}) async {
    final configProvider = context.read<ConfigProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();
    final itemsProvider = context.read<ItemsProvider>();

    await itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,
      forceRefresh: forceRefresh,
    );

    await configProvider.load();
  }

  void _onItemTapped(int index) {
    if (widget.selectedItem == index) return;

    setState(() {
      widget.selectedItem = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;

      case 1:
        context.push('/categorias');
        break;

      case 2:
        context.push('/buscar');
        break;

      case 3:
        context.push('/favoritos');
        break;

      case 4:
        context.push('/config');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha automáticamente los cambios de favoritos
    final favoritesProvider = context.watch<FavoritesProvider>();

    // Escucha cambios del ThemeMode
    context.watch<ConfigProvider>();

    final favoritesCount = favoritesProvider.count;
    final haveFavorites = favoritesCount > 0;

    // El brillo efectivo del tema (System, Dark o Light)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return NeoGlassNavigationBar(
    
  showLabels:false,
      currentIndex: widget.selectedItem,
      onTap: _onItemTapped,
      items: [
         NeoGlassNavItem(
          label: 'Inicio',
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
        ),
         NeoGlassNavItem(
          label: 'Categorias',
          icon: Icons.menu,
          activeIcon: Icons.menu_sharp,
        ),
         NeoGlassNavItem(
          label: 'Buscar',
          icon: Icons.search,
          activeIcon: Icons.search_rounded,
        ),
        NeoGlassNavItem(
          icon: CupertinoIcons.heart_fill,
          activeIcon: CupertinoIcons.heart,
          badge: favoritesCount.toString(),

          label: 'Favoritos',
        ),
        NeoGlassNavItem(
          icon: CupertinoIcons.gear_alt_fill,
          activeIcon: CupertinoIcons.gear_alt,
          label: "Opciones",
        ),
      ],
    );
  }
}
