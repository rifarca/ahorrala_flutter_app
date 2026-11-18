import 'package:hive_flutter/hive_flutter.dart';

class FavoritesServices {
  static const String boxName = "favorites_skus";

  Box<String>? _box;

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<String>(boxName);
    } else {
      _box = Hive.box<String>(boxName);
    }
  }

  Box<String> get box {
    if (_box == null) {
      throw Exception("FavoritesServices no inicializado");
    }

    return _box!;
  }

  List<String> getSkus() {
    return box.values.toList();
  }

  Future<void> add(String sku) async {
    await box.put(sku, sku);
  }

  Future<void> remove(String sku) async {
    await box.delete(sku);
  }

  bool contains(String sku) {
    return box.containsKey(sku);
  }

  Future<bool> toggle(String sku) async {
    if (contains(sku)) {
      await remove(sku);

      return false;
    }

    await add(sku);

    return true;
  }

  Future<void> clear() async {
    await box.clear();
  }
}
