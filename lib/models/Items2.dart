// ignore_for_file: file_names, non_constant_identifier_names


class Items {
  late int NegocioID;
  late String NegocioNombre;
  late String Titulo;
  late String Sku;
  late String Imagen;
  late int CategoriaID;
  late String CategoriaNombre;
  late int SubcategoriaID;
  late String SubcategoriaNombre;
  late int PrecioNuevo;
  late int PrecioViejo;
  late int PrecioOff;
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
    //var items_json = json['items'];

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
        Link: json['link']);
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['category_id'] = CategoriaID;
    data['category'] = CategoriaNombre;
    data['subcategory_id'] = SubcategoriaID;
    data['subcategory'] = SubcategoriaNombre;
    data['business_id'] = NegocioID;
    data['business'] = NegocioNombre;
    data['title'] = Titulo;
    data['price_now'] = PrecioNuevo;
    data['price_old'] = PrecioViejo;
    data['price_off'] = PrecioOff;
    data['image'] = Imagen;
    data['link'] = Link;
    return data;
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
        CategoriaID: map['category_id'],
        CategoriaNombre: map['category'],
        SubcategoriaID: map['subcategory_id'],
        SubcategoriaNombre: map['subcategory'],
        NegocioID: map['business_id'],
        NegocioNombre:  map['business'],
        Imagen: map['image'],
        Titulo: map['title'],
        Link: map['link'],
        PrecioNuevo: map['price_now'],
        PrecioViejo: map['price_old'],
        PrecioOff: map['price_off'],
        Sku: map['sku']);
  }
}
