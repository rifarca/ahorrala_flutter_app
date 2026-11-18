import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MenuCrystalBottomNavigationBar extends StatefulWidget {
  MenuCrystalBottomNavigationBar({super.key, required this.selectedItem});

  int selectedItem;

  @override
  State<MenuCrystalBottomNavigationBar> createState() =>
      _MenuCrystalBottomNavigationBarState();
}

class _MenuCrystalBottomNavigationBarState
    extends State<MenuCrystalBottomNavigationBar> {
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

    return CrystalNavigationBar(
      borderWidth: 1,
      enablePaddingAnimation: true,
      currentIndex: widget.selectedItem,
      selectedItemColor: const Color(0xFF10B981),
      unselectedItemColor: isDark
          ? const Color(0xFFDEDEDE)
          : const Color(0xFF131313),
      margin: const EdgeInsets.all(4),
      marginR: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? const Color.fromARGB(92, 28, 28, 28)
              : const Color.fromARGB(133, 249, 250, 251),
          spreadRadius: 5,
          blurRadius: 10,
          offset: const Offset(0, 0),
        ),
      ],
      onTap: _onItemTapped,
      items: [
        CrystalNavigationBarItem(
          icon: CupertinoIcons.house_fill,
          unselectedIcon: CupertinoIcons.house,
        ),
        CrystalNavigationBarItem(
          icon: Icons.menu_sharp,
          unselectedIcon: Icons.menu,
        ),
        CrystalNavigationBarItem(icon: CupertinoIcons.search),
        CrystalNavigationBarItem(
          icon: CupertinoIcons.heart_fill,
          unselectedIcon: CupertinoIcons.heart,
          badge: Badge(
            isLabelVisible: haveFavorites,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            label: Text(
              favoritesCount.toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        CrystalNavigationBarItem(
          icon: CupertinoIcons.gear_alt_fill,
          unselectedIcon: CupertinoIcons.gear_alt,
        ),
      ],
    );
  }
}
