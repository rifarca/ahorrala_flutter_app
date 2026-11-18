class Categories {
  late int id;
  late String name;
  late String image;
  late int subs;
  late int items;
  Categories({required this.id, required this.name, required this.image, required this.items, required this.subs});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
    id :json['category_id'],
    name : json['category'],
    image:  json['image'],
    items : json['items_total'],
    subs :   json['subcategories_total']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
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