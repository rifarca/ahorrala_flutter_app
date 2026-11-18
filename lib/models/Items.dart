// ignore_for_file: file_names, non_constant_identifier_names

// Paso 1: Anotar la clase con Hive
import 'package:hive_flutter/hive_flutter.dart';

part 'Items.g.dart';

@HiveType(typeId: 1)
class Items extends HiveObject {
  @HiveField(13)
  late int NegocioID;

  @HiveField(1)
  late String NegocioNombre;

  @HiveField(2)
  late String Titulo;

  @HiveField(3)
  late String Sku;

  @HiveField(4)
  late String Imagen;

  @HiveField(5)
  late int CategoriaID;

  @HiveField(6)
  late String CategoriaNombre;

  @HiveField(7)
  late int SubcategoriaID;

  @HiveField(8)
  late String SubcategoriaNombre;

  @HiveField(9)
  late int PrecioNuevo;

  @HiveField(10)
  late int PrecioViejo;

  @HiveField(11)
  late int PrecioOff;

  @HiveField(12)
  late String Link;

  Items({
    required this.Sku,
    required this.Titulo,
    required this.Imagen,
    required this.CategoriaID,
    required this.CategoriaNombre,
    required this.SubcategoriaNombre,
    required this.SubcategoriaID,
    required this.NegocioID,
    required this.NegocioNombre,
    required this.PrecioNuevo,
    required this.PrecioViejo,
    required this.PrecioOff,
    required this.Link,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      Sku: json['sku'],
      Titulo: json['title'],
      CategoriaID: json['category_id'],
      CategoriaNombre: json['category'],
      SubcategoriaID: json['subcategory_id'],
      SubcategoriaNombre: json['subcategory'],
      NegocioNombre: json['business'],
      NegocioID: json['business_id'],
      Imagen: json['image'],
      PrecioNuevo: json['price_now'],
      PrecioViejo: json['price_old'],
      PrecioOff: json['price_off'],
      Link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': CategoriaID,
      'category': CategoriaNombre,
      'subcategory_id': SubcategoriaID,
      'subcategory': SubcategoriaNombre,
      'business_id': NegocioID,
      'business': NegocioNombre,
      'title': Titulo,
      'price_now': PrecioNuevo,
      'price_old': PrecioViejo,
      'price_off': PrecioOff,
      'image': Imagen,
      'link': Link,
      'sku': Sku,
    };
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
      CategoriaID: map['category_id'],
      CategoriaNombre: map['category'],
      SubcategoriaID: map['subcategory_id'],
      SubcategoriaNombre: map['subcategory'],
      NegocioID: map['business_id'],
      NegocioNombre: map['business'],
      Imagen: map['image'],
      Titulo: map['title'],
      Link: map['link'],
      PrecioNuevo: map['price_now'],
      PrecioViejo: map['price_old'],
      PrecioOff: map['price_off'],
      Sku: map['sku'],
    );
  }
}

class ItemsBox {
  static const String boxName = "itemsBox";

  static Box<Items> getBox() {
    return Hive.box<Items>(boxName);
  }

  // Guardar un item individual

  static Future<void> saveItem(Items item) async {
    final box = getBox();

    await box.put(item.Sku, item);
  }

  // Obtener item por SKU

  static Items? getItem(String sku) {
    final box = getBox();

    return box.get(sku);
  }

  // Guardar lista de items relacionados

  static Future<void> saveList(String key, List<Items> items) async {
    final box = getBox();

    for (final item in items) {
      await box.put(key, item);
    }
  }

  // Obtener lista usando SKUs

  static List<Items> getList(List<String> skus) {
    final box = getBox();

    List<Items> result = [];

    for (final sku in skus) {
      final item = box.get(sku);

      if (item != null) {
        result.add(item);
      }
    }

    return result;
  }

  static Future<void> saveAllAndClear(List<Items> remoteItems) async {}
}
