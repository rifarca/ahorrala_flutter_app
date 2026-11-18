// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/Categories.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Categories> _categories = [];

  bool _loading = false;

  bool _loaded = false;

  List<Categories> get categories => _categories;

  bool get loading => _loading;

  bool get loaded => _loaded;

  /// Carga inicial
  /// 1 - Hive
  /// 2 - API en segundo plano
  Future<void> loadCategories() async {
    // Evita cargar varias veces
    if (_loaded) {
      return;
    }

    // Primero cargar cache local
    final cache = CategoriesBox.getAllCategories();

    if (cache.isNotEmpty) {
      _categories = cache;

      _loaded = true;

      notifyListeners();
    }

    // Si ya hay datos igual actualizamos en background
    await _fetchFromApi();
  }

  /// Obtener desde servidor
  Future<void> _fetchFromApi() async {
    if (_loading) return;

    _loading = true;

    notifyListeners();

    try {
      final data = await Helper.getCategoriesList();

      if (data.isNotEmpty) {
        _categories = data;

        // limpiar cache vieja
        final box = CategoriesBox.getBox();

        await box.clear();

        // guardar nueva cache
        await box.addAll(data);
      }
    } catch (e) {
      debugPrint("Error cargando categorias: $e");
    }

    _loading = false;

    _loaded = true;

    notifyListeners();
  }

  /// Forzar actualización manual
  Future<void> refreshCategories() async {
    _loaded = false;

    await _fetchFromApi();
  }

  /// Buscar categoria por ID
  Categories? getById(int id) {
    try {
      return _categories.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
