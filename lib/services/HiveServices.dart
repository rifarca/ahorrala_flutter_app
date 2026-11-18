import 'package:hive_flutter/hive_flutter.dart';

import '../models/Categories.dart';
import '../models/Items.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Registrar adapters
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ItemsAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(CategoriesAdapter());
    }

    // Abrir cajas
    await Hive.openBox<Items>('itemsBox');

    await Hive.openBox<Categories>('categoriesBox');
  }
}
