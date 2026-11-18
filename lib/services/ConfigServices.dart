import 'package:hive_flutter/hive_flutter.dart';

class ConfigService {
  static const String boxName = "config";

  static Future<Box> getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }

    return await Hive.openBox(boxName);
  }

  static Future<void> init() async {
    final box = await getBox();

    await setDefault(box, "theme_mode", "system");

    await setDefault(box, "items_results_total", 20);

    await setDefault(box, "items_random", false);

    await setDefault(box, "cache_items_expire_minutes", 60);

    await setDefault(box, "item_detail_cache_expire_minutes", 120);

    await setDefault(box, "device_id", "");

    await setDefault(box, "show_items_grid_total", 3);

    await setDefault(box, "user_online", false);
  }

  static Future<void> setDefault(Box box, String key, dynamic value) async {
    if (!box.containsKey(key)) {
      await box.put(key, value);
    }
  }

  static Future<dynamic> get(String key) async {
    final box = await getBox();

    return box.get(key);
  }

  static Future<void> set(String key, dynamic value) async {
    final box = await getBox();

    await box.put(key, value);
  }

  static Future<void> clear() async {
    final box = await getBox();

    await box.clear();
  }
}
