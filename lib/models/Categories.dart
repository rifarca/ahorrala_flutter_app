// ignore_for_file: file_names, non_constant_identifier_names
import 'package:hive_flutter/hive_flutter.dart';

// Paso 1: Anotar la clase con Hive
part 'Categories.g.dart';

@HiveType(typeId: 2)
class Categories extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String image;

  @HiveField(3)
  late int subs;

  @HiveField(4)
  late int items;

  Categories({
    required this.id,
    required this.name,
    required this.image,
    required this.items,
    required this.subs,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['category_id'],
      name: json['category'],
      image: json['image'],
      items: json['items_total'],
      subs: json['subcategories_total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = id;
    data['category'] = name;
    data['image'] = image;
    data['items_total'] = items;
    data['subcategories_total'] = subs;
    return data;
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['category_id'],
      name: map['category'],
      image: map['image'],
      items: map['items_total'],
      subs: map['subcategories_total'],
    );
  }
}

// Paso 2: Manejar la caja de Hive
class CategoriesBox {
  static const String _boxName = 'categoriesBox';

  /// Inicializa Hive y abre la caja
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoriesAdapter());
    await Hive.openBox<Categories>(_boxName);
  }

  /// Obtiene la caja
  static Box<Categories> getBox() => Hive.box<Categories>(_boxName);

  /// Agrega una nueva categoría
  static Future<void> addCategory(Categories category) async {
    final box = getBox();
    await box.add(category);
  }

  /// Agrega una lista de categorías
  static Future<void> addAllCategories(List<Categories> categories) async {
    final box = getBox();
    await box.addAll(categories);
  }
  /// Actualiza una categoría existente
  static Future<void> updateCategory(int index, Categories updatedCategory) async {
    final box = getBox();
    await box.putAt(index, updatedCategory);
  }

  /// Elimina una categoría por índice
  static Future<void> deleteCategory(int index) async {
    final box = getBox();
    await box.deleteAt(index);
  }

  /// Obtiene todas las categorías
  static List<Categories> getAllCategories() {
    final box = getBox();
    return box.values.toList();
  }
}
