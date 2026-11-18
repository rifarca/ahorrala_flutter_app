// ============================================================
// ROUTER
// ============================================================

import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/screens/AuthScreen.dart';
import 'package:ahorrala/screens/BarcodeScannerScreen.dart';
import 'package:ahorrala/screens/HomeScreen.dart';
import 'package:ahorrala/screens/ReviewScreen.dart';
import 'package:ahorrala/screens/SearcherScreen.dart';
import 'package:ahorrala/screens/TourScreen.dart';
import 'package:flutter/material.dart'; // Asegúrate de importar material para Curves y Transitions
import 'package:ahorrala/models/Categories.dart';
import 'package:ahorrala/pages/PageBrands.dart';
import 'package:ahorrala/screens/CategoriesScreen.dart';
import 'package:ahorrala/screens/ConfigScreen.dart';
import 'package:ahorrala/screens/FavoritesScreen.dart';
import 'package:ahorrala/screens/ItemDetailScreen.dart';
import 'package:ahorrala/screens/ItemsCategoryScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/Items.dart';

final router = GoRouter(
  routes: <RouteBase>[
    // WELLCOME: Suele ser la pantalla base, no necesita animación de entrada inicial
    GoRoute(
      path: '/',
      /*  builder: (context, state) {
        return WelcomeScreen();
        //return HomeScreen(title: 'Ahorrala');
      },*/
      pageBuilder: (context, state) {
        context
            .read<ConfigProvider>()
            .load(); // Asegúrate de cargar la configuración antes de decidir qué pantalla mostrar
        return CustomTransitionPage(
          key: state.pageKey,
          child: HomeScreen(title: 'Ahorrala'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // HOME: Suele ser la pantalla base, no necesita animación de entrada inicial
    GoRoute(
      path: '/home',

      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: HomeScreen(title: 'Ahorrala'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    // Autj: Suele ser la pantalla base, no necesita animación de entrada inicial
    GoRoute(
      path: '/auth',

      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: AuthScreen(title: 'Ahorrala'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    // TOUR: Suele ser la pantalla base, no necesita animación de entrada inicial
    GoRoute(
      path: '/review',
      builder: (context, state) {
        //return WelcomeScreen();
        return ReviewScreen(title: 'Rebview');
      },
    ),
    // TOUR: Suele ser la pantalla base, no necesita animación de entrada inicial
    GoRoute(
      path: '/tour',
      builder: (context, state) {
        //return WelcomeScreen();
        return TourScreen(title: 'Ahorrala');
      },
    ),

    // ========================================================
    // ITEM CON TITULO (Efecto: Deslizar desde la Derecha)
    // ========================================================
    GoRoute(
      path: '/items/:sku/:title',
      pageBuilder: (context, state) {
        final String sku = state.pathParameters['sku'] ?? '';
        final Items? data = state.extra as Items?;

        return CustomTransitionPage(
          key: state.pageKey,
          child: ItemDetailScreen(
            sku: sku,
            title: data?.Titulo ?? '',
            image: data?.Imagen ?? '',
            category_id: data?.CategoriaID ?? 4,
            category: data?.CategoriaNombre ?? '',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ========================================================
    // ITEM (Efecto: Deslizar desde la Derecha)
    // ========================================================
    GoRoute(
      path: '/items/:sku',
      pageBuilder: (context, state) {
        final String sku = state.pathParameters['sku'] ?? '';
        Items? data = state.extra as Items?;

        return CustomTransitionPage(
          key: state.pageKey,
          child: ItemDetailScreen(
            sku: sku,
            title: data?.Titulo ?? '',
            image: data?.Imagen ?? '',
            category_id: data?.CategoriaID ?? 0,
            category: data?.CategoriaNombre ?? '',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ========================================================
    // CATEGORIAS (Efecto: Desvanecimiento / Fade)
    // ========================================================
    GoRoute(
      path: '/categorias',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const CategoriesScreen(title: 'Categorias'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ========================================================
    // ITEMS POR CATEGORIA (Efecto: Deslizar desde la Derecha)
    // ========================================================
    GoRoute(
      path: '/categorias/:cat',
      pageBuilder: (context, state) {
        final String cat = state.pathParameters['cat'] ?? '0';
        final Categories? data = state.extra as Categories?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ItemsCategoryScreen(
            categoria_id: int.tryParse(cat) ?? 0,
            categoria: data?.name ?? '',
            imagen: '',
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ========================================================
    // MARCAS (Efecto: Escala / Zoom)
    // ========================================================
    GoRoute(
      path: '/marcas',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const PageBrands(title: 'Marcas'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ========================================================
    // BUSCAR (Efecto: Deslizar desde abajo - Estilo Modal)
    // ========================================================dove
    GoRoute(
      path: '/buscar',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: SearcherScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ========================================================
    // FAVORITOS (Efecto: Desvanecimiento / Fade)
    // ========================================================
    GoRoute(
      path: '/favoritos',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: FavoritesScreen(title: 'Mis Productos Favoritos'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    // ========================================================
    // SCANNER (Efecto: Desvanecimiento / Fade)
    // ========================================================
    GoRoute(
      path: '/scanner',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: BarcodeScannerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // ========================================================
    // CONFIGURACIÓN (Efecto: Deslizar desde la Derecha)
    // ========================================================
    GoRoute(
      path: '/config',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ConfigScreen(title: 'Opciones'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0), // Entra por abajo (Y = 1.0)
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
              ),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
