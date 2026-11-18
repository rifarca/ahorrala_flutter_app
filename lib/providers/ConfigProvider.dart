import 'package:flutter/material.dart';

import '../services/ConfigServices.dart';

class ConfigProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  int itemsResultsTotal = 24;
  bool autoHideBottomBar = false;
  bool itemsRandom = false;
  int cacheItemsExpireMinutes = 2;

  int itemDetailCacheExpireMinutes = 5;

  int showItemsGridTotal = 2;

  bool userOnline = false;
  bool showWellcomScreen = true;

  Future<void> load() async {
    await ConfigService.init();

    themeMode = _parseTheme(await ConfigService.get("theme_mode"));

    itemsResultsTotal = await ConfigService.get("items_results_total") ?? 20;

    itemsRandom = await ConfigService.get("items_random") ?? false;

    cacheItemsExpireMinutes =
        await ConfigService.get("cache_items_expire_minutes") ?? 60;

    itemDetailCacheExpireMinutes =
        await ConfigService.get("item_detail_cache_expire_minutes") ?? 120;

    showItemsGridTotal = await ConfigService.get("show_items_grid_total") ?? 3;

    userOnline = await ConfigService.get("user_online") ?? false;
    autoHideBottomBar =
        await ConfigService.get('auto_hide_bottom_bar') ?? false;
    showWellcomScreen = await ConfigService.get('show_wellcome_screen') ?? true;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    themeMode = mode;

    await ConfigService.set("theme_mode", mode.name);

    notifyListeners();
  }

  Future<void> setItemsRandom(bool value) async {
    itemsRandom = value;

    await ConfigService.set("items_random", value);

    notifyListeners();
  }

  Future<void> setAutoHideBottomBar(bool value) async {
    autoHideBottomBar = value;

    await ConfigService.set("auto_hide_bottom_bar", value);

    notifyListeners();
  }

  Future<void> setItemsResultsTotal(int value) async {
    itemsResultsTotal = value;

    await ConfigService.set("items_results_total", value);

    notifyListeners();
  }

  Future<void> setCacheItemsExpire(int minutes) async {
    cacheItemsExpireMinutes = minutes;

    await ConfigService.set("cache_items_expire_minutes", minutes);

    notifyListeners();
  }

  Future<void> setShowWellcomeScreen(bool show) async {
    showWellcomScreen = show;

    await ConfigService.set("show_wellcome_screen", showWellcomScreen);

    notifyListeners();
  }

  ThemeMode _parseTheme(String? value) {
    switch (value) {
      case "light":
        return ThemeMode.light;

      case "dark":
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  Future<void> setCacheItemsExpireMinutes(int value) async {
    cacheItemsExpireMinutes = value;

    await ConfigService.set("cache_items_expire_minutes", value);

    notifyListeners();
  }
}
