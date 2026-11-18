import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../helpers/helper.dart';
import '../models/Items.dart';
import 'ConfigProvider.dart';

class ItemsProvider extends ChangeNotifier {
  // ============================================================
  // CACHE EN MEMORIA
  // ============================================================

  final Map<String, List<Items>> itemsCache = {};
  // ============================================================
  // INDEX POR SKU
  // ============================================================

  final Map<String, Items> itemsIndex = {};
  // ============================================================
  // ESTADOS
  // ============================================================

  final Map<String, bool> loading = {};
  final Map<String, bool> finished = {};
  final Map<String, int> totalResult = {};
  int totalResultLast = 0;
  // ============================================================
  // CONFIG
  // ============================================================

  Duration cacheTTL = const Duration(minutes: 30);

  bool itemsRandom = false;
  int itemsTotalResult = 24;

  // ============================================================
  // CONFIG PROVIDER DINAMICO
  // ============================================================

  void updateConfig(ConfigProvider config) {
    final newTTL = Duration(
      minutes: config.cacheItemsExpireMinutes > 0
          ? config.cacheItemsExpireMinutes
          : 30,
    );

    final newRandom = config.itemsRandom;

    final ttlChanged = cacheTTL != newTTL;
    final randomChanged = itemsRandom != newRandom;

    if (!ttlChanged && !randomChanged) {
      return;
    }
    itemsTotalResult = config.itemsResultsTotal;
    cacheTTL = newTTL;
    itemsRandom = newRandom;

    debugPrint(
      '⚙️ ITEMS CONFIG UPDATED '
      'TTL=${cacheTTL.inMinutes} '
      'RANDOM=$itemsRandom',
    );

    if (randomChanged && itemsRandom) {
      _shuffleMemoryCache();
    }
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // ============================================================
  // CONFIG MANUAL
  // ============================================================

  void setCacheTTL(int minutes) {
    final newTTL = Duration(minutes: minutes > 0 ? minutes : 30);

    if (cacheTTL == newTTL) {
      return;
    }

    cacheTTL = newTTL;

    debugPrint(
      '⚙️ ITEMS CACHE TTL UPDATED: '
      '${cacheTTL.inMinutes} minutos',
    );

    notifyListeners();
  }

  void setRandomItems(bool value) {
    if (itemsRandom == value) {
      return;
    }

    itemsRandom = value;

    if (itemsRandom) {
      _shuffleMemoryCache();
    }

    debugPrint('🔀 RANDOM ITEMS: $itemsRandom');

    notifyListeners();
  }

  // ============================================================
  // RANDOM
  // ============================================================

  List<Items> _shuffleItems(List<Items> items) {
    final result = List<Items>.from(items);

    if (itemsRandom) {
      result.shuffle();
    }

    return result;
  }

  void _shuffleMemoryCache() {
    if (!itemsRandom) {
      return;
    }

    for (final key in itemsCache.keys.toList()) {
      itemsCache[key] = _shuffleItems(itemsCache[key] ?? <Items>[]);
    }

    debugPrint('🔀 MEMORY CACHE SHUFFLED');
  }

  // ============================================================
  // INDEX ITEMS
  // ============================================================

  void _indexItems(List<Items> items) {
    for (final item in items) {
      itemsIndex[item.Sku.toString()] = item;
    }

    debugPrint('📌 INDEX UPDATED: ${itemsIndex.length}');
  }

  // ============================================================
  // GETTERS DE ESTADO
  // ============================================================

  bool isLoading(String key) {
    return loading[key] ?? false;
  }

  bool isFinished(String key) {
    return finished[key] ?? false;
  }

  int getTotalResult(String key) {
    return totalResult[key] ?? 0;
  }

  List<Items> getItems(String key) {
    return itemsCache[key] ?? <Items>[];
  }

  bool haveItems(String key) {
    return itemsCache[key]?.isNotEmpty ?? false;
  }

  // ============================================================
  // KEYS
  // ============================================================

  String categoryKey(int categoryId) {
    return 'items_cat_$categoryId';
  }

  String relativeCategoryKey(String sku) {
    return 'items_relative_cat_$sku';
  }

  String relativeBrandKey(String sku) {
    return 'items_relative_brand_$sku';
  }

  String compareKey(String sku) {
    return 'items_compare_$sku';
  }

  String brandKey(int brandId) {
    return 'items_brand_$brandId';
  }

  String favoriteKey() {
    return 'items_favorites';
  }

  String searchKey(String query) {
    final value = query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');

    return 'items_search_$value';
  }

  // ============================================================
  // HIVE
  // ============================================================

  Future<Box<dynamic>> _openBox(String key) async {
    if (Hive.isBoxOpen(key)) {
      return Hive.box<dynamic>(key);
    }

    return Hive.openBox<dynamic>(key);
  }

  Future<bool> _isCacheExpired(String key) async {
    try {
      final box = await _openBox(key);

      final created = box.get('__created_at');

      if (created == null) {
        return true;
      }

      final createdAt = DateTime.tryParse(created.toString());

      if (createdAt == null) {
        return true;
      }

      final expired = DateTime.now().difference(createdAt) > cacheTTL;

      if (expired) {
        debugPrint(
          '⏰ CACHE EXPIRED [$key] '
          'TTL=${cacheTTL.inMinutes}',
        );
      }

      return expired;
    } catch (e) {
      debugPrint('❌ CACHE DATE ERROR [$key]: $e');

      return true;
    }
  }

  Future<List<Items>> _readCache(String key) async {
    if (await _isCacheExpired(key)) {
      await _deleteCache(key);

      return <Items>[];
    }

    try {
      final box = await _openBox(key);

      if (box.isEmpty) {
        debugPrint('📭 HIVE EMPTY [$key]');

        return <Items>[];
      }

      final List<Items> result = [];

      for (final entry in box.toMap().entries) {
        if (entry.key == '__created_at') {
          continue;
        }

        final value = entry.value;

        try {
          if (value is Items) {
            result.add(value);

            continue;
          }

          if (value is Map) {
            result.add(Items.fromJson(Map<String, dynamic>.from(value)));
          }
        } catch (e) {
          debugPrint('⚠️ HIVE ITEM ERROR [$key]: $e');
        }
      }

      final items = _shuffleItems(result);

      debugPrint(
        '📦 HIVE READ [$key]: ${items.length} '
        'RANDOM=$itemsRandom',
      );

      return items;
    } catch (e, stackTrace) {
      debugPrint('❌ HIVE READ ERROR [$key]: $e');

      debugPrint('$stackTrace');

      return <Items>[];
    }
  }

  Future<void> _saveCache(String key, List<Items> items) async {
    try {
      final box = await _openBox(key);

      await box.clear();

      if (items.isEmpty) {
        debugPrint('📭 NOT SAVING EMPTY CACHE [$key]');

        return;
      }

      final Map<String, dynamic> data = {};

      for (var index = 0; index < items.length; index++) {
        final item = items[index];

        final cacheKey = '${item.Sku}_$index';

        data[cacheKey] = item.toJson();
      }

      await box.putAll(data);

      await box.put('__created_at', DateTime.now().toIso8601String());

      debugPrint('💾 HIVE SAVED [$key]: ${items.length}');
    } catch (e, stackTrace) {
      debugPrint('❌ HIVE SAVE ERROR [$key]: $e');

      debugPrint('$stackTrace');
    }
  }

  Future<void> _deleteCache(String key) async {
    final removedItems = itemsCache.remove(key);

    if (removedItems != null) {
      for (final item in removedItems) {
        itemsIndex.remove(item.Sku.toString());
      }
    }
    loading.remove(key);
    finished.remove(key);
    totalResult.remove(key);

    try {
      if (Hive.isBoxOpen(key)) {
        final box = Hive.box<dynamic>(key);

        await box.clear();
        await box.close();
      }

      if (await Hive.boxExists(key)) {
        await Hive.deleteBoxFromDisk(key);
      }

      debugPrint('🗑️ CACHE DELETED [$key]');
    } catch (e) {
      debugPrint('❌ DELETE CACHE ERROR [$key]: $e');
    }
  }

  // ============================================================
  // GENERIC LOADER
  // ============================================================

  Future<void> _load({
    required String key,
    required Future<List<Items>> Function() request,
    bool forceRefresh = false,
  }) async {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('🚀 LOAD START [$key]');
    debugPrint('FORCE REFRESH: $forceRefresh');
    debugPrint('TTL: ${cacheTTL.inMinutes}');
    debugPrint('RANDOM: $itemsRandom');
    debugPrint('========================================');

    if (loading[key] == true) {
      debugPrint('⏳ ALREADY LOADING [$key]');

      return;
    }

    final memoryItems = itemsCache[key];

    if (!forceRefresh && memoryItems != null && memoryItems.isNotEmpty) {
      totalResult[key] = memoryItems.length;
      finished[key] = true;
      if (key.contains("search")) {
        totalResultLast = memoryItems.length;
      }

      debugPrint('🧠 MEMORY HIT [$key]: ${memoryItems.length}');

      return;
    }

    loading[key] = true;
    finished[key] = false;

    notifyListeners();

    try {
      // ========================================================
      // HIVE
      // ========================================================

      if (!forceRefresh) {
        debugPrint('🔎 CHECKING HIVE [$key]');

        final cache = await _readCache(key);

        if (cache.isNotEmpty) {
          final hiveItems = List<Items>.from(cache);

          itemsCache[key] = hiveItems;

          _indexItems(hiveItems);

          totalResult[key] = hiveItems.length;
          if (key.contains("search")) {
            totalResultLast = hiveItems.length;
          }

          debugPrint('📦 HIVE HIT [$key]: ${hiveItems.length}');

          return;
        }
        debugPrint('📭 HIVE MISS [$key]');
      }

      // ========================================================
      // API
      // ========================================================

      debugPrint('🌐 API REQUEST [$key]');

      final apiItems = await request();
      List<Items> memoryItems = [];
      /*if (key == 'items_favorites') {
        List<Items> favItem = [];
        favItem.add(apiItems.elementAt(0));
        debugPrint('🌐 API RESPONSE [$key]: ${favItem.length}');

        // Guardamos la respuesta original en Hive.
        // El orden random pertenece a presentación/memoria.

        if (apiItems.isNotEmpty) {
          await _saveCache(key, favItem);
        }

        memoryItems = _shuffleItems(favItem);
      } else {*/
      debugPrint('🌐 API RESPONSE [$key]: ${apiItems.length}');

      // Guardamos la respuesta original en Hive.
      // El orden random pertenece a presentación/memoria.

      if (apiItems.isNotEmpty) {
        await _saveCache(key, apiItems);
      }

      memoryItems = _shuffleItems(apiItems);
      //// }
      itemsCache[key] = memoryItems;

      _indexItems(memoryItems);

      totalResult[key] = memoryItems.length;
      debugPrint(
        '🔀 MEMORY ITEMS [$key]: '
        '${memoryItems.length} RANDOM=$itemsRandom',
      );
    } catch (e, stackTrace) {
      debugPrint('');
      debugPrint('❌ ITEM PROVIDER ERROR [$key]');

      debugPrint('ERROR: $e');

      debugPrint('$stackTrace');

      itemsCache.remove(key);

      totalResult[key] = 0;
    } finally {
      loading[key] = false;
      finished[key] = true;

      debugPrint('🏁 LOAD FINISHED [$key]');

      debugPrint('TOTAL: ${totalResult[key] ?? 0}');

      debugPrint('========================================');

      notifyListeners();
    }
  }

  // ============================================================
  // FAVORITES BY SKU
  // ============================================================

  Future<void> loadItemsFavorites(
    List<String> skus, {
    bool forceRefresh = false,
  }) async {
    const key = 'items_favorites';

    // Limpiar y eliminar SKUs duplicados
    final cleanSkus = skus
        .map((sku) => sku.trim())
        .where((sku) => sku.isNotEmpty)
        .toSet()
        .toList();

    if (cleanSkus.isEmpty) {
      itemsCache[key] = <Items>[];
      totalResult[key] = 0;
      finished[key] = true;
      loading[key] = false;

      notifyListeners();
      return;
    }

    loading[key] = true;
    finished[key] = false;

    notifyListeners();

    try {
      debugPrint('');
      debugPrint('========================================');
      debugPrint('❤️ LOAD FAVORITES');
      debugPrint('TOTAL SKUS: ${cleanSkus.length}');
      debugPrint('========================================');

      final Map<String, Items> uniqueItems = {};

      final List<String> missingSkus = [];

      // ============================================================
      // BUSCAR PRIMERO EN CACHE / INDEX
      // ============================================================

      if (!forceRefresh) {
        for (final sku in cleanSkus) {
          final cachedItem = itemsIndex[sku];

          if (cachedItem != null) {
            debugPrint('⚡ CACHE HIT [$sku]');

            uniqueItems[sku] = cachedItem;
          } else {
            debugPrint('🌐 CACHE MISS [$sku]');

            missingSkus.add(sku);
          }
        }
      } else {
        missingSkus.addAll(cleanSkus);
      }

      debugPrint('');
      debugPrint('⚡ CACHE FOUND: ${uniqueItems.length}');
      debugPrint('🌐 API REQUIRED: ${missingSkus.length}');

      // ============================================================
      // DESCARGAR SOLO LOS SKU FALTANTES
      // ============================================================

      if (missingSkus.isNotEmpty) {
        final responses = await Future.wait(
          missingSkus.map((sku) async {
            try {
              debugPrint('➡️ Helper.getItemsDetails($sku)');

              final result = await Helper.getItemsDetails(sku);

              debugPrint('❤️ SKU [$sku] RESPONSE: ${result.length}');

              return result;
            } catch (e) {
              debugPrint('❌ FAVORITE SKU ERROR [$sku]: $e');

              return <Items>[];
            }
          }),
        );

        // ============================================================
        // AGREGAR RESULTADOS
        // ============================================================

        for (final items in responses) {
          for (final item in items) {
            final sku = item.Sku.toString();

            uniqueItems[sku] = item;
          }
        }
      }

      // ============================================================
      // RESPETAR ORDEN DE FAVORITOS
      // ============================================================

      final result = cleanSkus
          .map((sku) => uniqueItems[sku])
          .whereType<Items>()
          .toList();

      debugPrint('');
      debugPrint('❤️ FAVORITES FOUND: ${result.length}');

      // ============================================================
      // GUARDAR CACHE
      // ============================================================

      if (result.isNotEmpty) {
        await _saveCache(key, result);
      }

      itemsCache[key] = result;

      // Actualizar índice global
      _indexItems(result);

      totalResult[key] = result.length;
    } catch (e, stackTrace) {
      debugPrint('❌ FAVORITES ERROR: $e');
      debugPrint('$stackTrace');

      itemsCache[key] = <Items>[];
      totalResult[key] = 0;
    } finally {
      loading[key] = false;
      finished[key] = true;

      debugPrint('🏁 FAVORITES FINISHED: ${totalResult[key] ?? 0}');

      notifyListeners();
    }
  }
  // ============================================================
  // ITEMS BY CATEGORY
  // ============================================================

  Future<void> loadItemsByCategory({
    required int categoryId,
    int sub = 0,
    int limit = 16,
    bool forceRefresh = false,
  }) async {
    final key = categoryKey(categoryId);

    await _load(
      key: key,
      forceRefresh: forceRefresh,
      request: () async {
        debugPrint(
          '➡️ Helper.getItemsListByCategory'
          '($categoryId, $sub, $limit)',
        );

        return Helper.getItemsListByCategory(
          cat: categoryId,
          sub: sub,
          limit: itemsTotalResult,
        );
      },
    );
  }

  // ============================================================
  // ITEMS RELATIVE BY CATEGORY
  // ============================================================
  Future<void> loadItemsRelativeByCategory({
    required String sku,
    bool forceRefresh = false,
  }) async {
    final cleanSku = sku.trim();

    if (cleanSku.isEmpty) {
      debugPrint('❌ RELATIVE CATEGORY: SKU EMPTY');

      return;
    }

    final key = relativeCategoryKey(cleanSku);

    await _load(
      key: key,
      forceRefresh: forceRefresh,
      request: () async {
        debugPrint('➡️ Helper.getItemsRelativesByCategory($cleanSku)');

        return Helper.getItemsRelativesByCategory(cleanSku);
      },
    );
  }

  // ============================================================
  // ITEMS COMPARE BY SKU
  // ============================================================

  Future<void> loadItemsCompareBySKU({
    required String sku,
    bool forceRefresh = false,
  }) async {
    final cleanSku = sku.trim();

    if (cleanSku.isEmpty) {
      return;
    }

    final key = compareKey(cleanSku);
    final rnd = itemsRandom;
    setRandomItems(false);
    await _load(
      key: key,
      forceRefresh: true,
      request: () async {
        debugPrint('➡️ Helper.getItemsCompare($cleanSku)');

        return Helper.getItemsCompare(cleanSku);
      },
    );
    setRandomItems(rnd);
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<void> searchItems({
    required String query,
    bool forceRefresh = false,
    int cat_id = 0,
    int limit = 24,
    String field = "title",
    String order = "ASC",
  }) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return;
    }

    final key = searchKey(cleanQuery);

    await _load(
      key: key,
      forceRefresh: forceRefresh,
      request: () async {
        debugPrint('🔎 SEARCH ITEMS: $cleanQuery');

        return Helper.getItemsBuscar(
          query: query,
          cat: cat_id,
          limit: limit,
          field: field,
          order: order,
        );
      },
    );
  }

  /* Future<void> searchItems2({
    required String query,
    int categoryId = 0,
    String field = "title",
    String order = "ASC",
    int limit = 24,
  }) async {
    loading["search"] = true;

    notifyListeners();

    final result = await Helper.getItemsBuscar(
      query: query,

      cat: categoryId,
      field: field,
      order: order,

      limit: limit,
    );

    itemsSearchResults = result;

    loading["search"] = false;

    notifyListeners();
  }*/
  // ============================================================
  // GETTERS ESPECIFICOS
  // ============================================================

  List<Items> getItemsByCategory(int categoryId) {
    return getItems(categoryKey(categoryId));
  }

  List<Items> getItemsRelativeByCategory(String sku) {
    return getItems(relativeCategoryKey(sku.trim()));
  }

  List<Items> getItemsRelativeByBrand(String sku) {
    return getItems(relativeBrandKey(sku.trim()));
  }

  List<Items> getItemsCompareBySKU(String sku) {
    return getItems(compareKey(sku.trim()));
  }

  List<Items> getItemsByBrand(int brandId) {
    return getItems(brandKey(brandId));
  }

  List<Items> getItemsBySearch(String query) {
    return getItems(searchKey(query));
  }

  List<Items> getItemsFavorites() {
    return getItems("items_favorites");
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshCategory({
    required int categoryId,
    int sub = 0,
    int limit = 16,
  }) async {
    await loadItemsByCategory(
      categoryId: categoryId,
      sub: sub,
      limit: itemsTotalResult,
      forceRefresh: true,
    );
  }

  Future<void> refreshRelativeCategory({required String sku}) async {
    await loadItemsRelativeByCategory(sku: sku, forceRefresh: true);
  }

  Future<void> refreshCompare({required String sku}) async {
    await loadItemsCompareBySKU(sku: sku, forceRefresh: true);
  }
  /*
  Future<void> refreshSearch({required String query}) async {
    await searchItems(query: query, forceRefresh: true);
  }*/

  // ============================================================
  // CLEAR CACHE
  // ============================================================

  Future<void> clearCache(String key) async {
    await _deleteCache(key);

    notifyListeners();
  }

  Future<void> clearCategoryCache(int categoryId) async {
    await clearCache(categoryKey(categoryId));
  }

  Future<void> clearRelativeCategoryCache(String sku) async {
    await clearCache(relativeCategoryKey(sku.trim()));
  }

  Future<void> clearCompareCache(String sku) async {
    await clearCache(compareKey(sku.trim()));
  }

  Future<void> clearSearchCache(String query) async {
    await clearCache(searchKey(query));
  }

  // ============================================================
  // CLEAR MEMORY
  // ============================================================

  void clearAllMemoryCache() {
    itemsCache.clear();

    itemsIndex.clear();

    loading.clear();

    finished.clear();

    totalResult.clear();

    debugPrint('🗑️ MEMORY CACHE CLEARED');

    notifyListeners();
  }
}
