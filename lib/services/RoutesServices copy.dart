// ============================================================
// ROUTER
// ============================================================

import 'package:ahorrala/models/Categories.dart';
import 'package:ahorrala/pages/PageBrands.dart';
import 'package:ahorrala/screens/CategoriesScreen.dart';
import 'package:ahorrala/screens/ConfigScreen.dart';
import 'package:ahorrala/screens/FavoritesScreen.dart';
import 'package:ahorrala/screens/HomeScreen.dart';
import 'package:ahorrala/screens/ItemDetailScreen.dart';
import 'package:ahorrala/screens/ItemsCategoryScreen.dart';
import 'package:ahorrala/screens/SearcherScreen.dart';
import 'package:go_router/go_router.dart';

import '../models/Items.dart';

final router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomeScreen(title: 'Ahorrala');
      },
    ),

    // ========================================================
    // ITEM CON TITULO
    // ========================================================
    GoRoute(
      path: '/items/:sku/:title',
      builder: (context, state) {
        final String sku = state.pathParameters['sku'] ?? '';

        final Items? data = state.extra as Items?;

        return ItemDetailScreen(
          sku: sku,
          title: data?.Titulo ?? '',
          image: data?.Imagen ?? '',
          category_id: data?.CategoriaID ?? 4,
          category: data?.CategoriaNombre ?? '',
        );
      },
    ),

    // ========================================================
    // ITEM
    // ========================================================
    GoRoute(
      path: '/items/:sku',
      builder: (context, state) {
        final String sku = state.pathParameters['sku'] ?? '';

        final Items? data = state.extra as Items?;

        return ItemDetailScreen(
          sku: sku,
          title: data?.Titulo ?? '',
          image: data?.Imagen ?? '',
          category_id: data?.CategoriaID ?? 0,
          category: data?.CategoriaNombre ?? '',
        );
      },
    ),

    // ========================================================
    // CATEGORIAS
    // ========================================================
    GoRoute(
      path: '/categorias',
      builder: (context, state) {
        return const CategoriesScreen(title: 'Categorias');
      },
    ),

    // ========================================================
    // ITEMS POR CATEGORIA
    // ========================================================
    GoRoute(
      path: '/categorias/:cat',
      builder: (context, state) {
        final String cat = state.pathParameters['cat'] ?? '0';

        final Categories? data = state.extra as Categories?;

        return ItemsCategoryScreen(
          categoria_id: int.tryParse(cat) ?? 0,
          categoria: data?.name ?? '',
          imagen: '',
        );
      },
    ),

    // ========================================================
    // MARCAS
    // ========================================================
    GoRoute(
      path: '/marcas',
      builder: (context, state) {
        return const PageBrands(title: 'Marcas');
      },
    ),

    // ========================================================
    // BUSCAR
    // ========================================================
    GoRoute(
      path: '/buscar',
      builder: (context, state) {
        return SearcherScreen();
      },
    ),

    // ========================================================
    // FAVORITOS
    // ========================================================
    GoRoute(
      path: '/favoritos',
      builder: (context, state) {
        return FavoritesScreen(title: 'Mis Productos Favoritos');
      },
    ),
    // ========================================================
    // FAVORITOS
    // ========================================================
    GoRoute(
      path: '/config',
      builder: (context, state) {
        return ConfigScreen(title: 'Opciones');
      },
    ),
  ],
);
