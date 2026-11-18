class ProductItemModel {
  String? _sku;
  List<Collections>? _collections;

  ProductItemModel({String? sku, List<Collections>? collections}) {
    if (sku != null) {
      _sku = sku;
    }
    if (collections != null) {
      _collections = collections;
    }
  }

  String? get sku => _sku;
  set sku(String? sku) => _sku = sku;
  List<Collections>? get collections => _collections;
  set collections(List<Collections>? collections) => _collections = collections;

  ProductItemModel.fromJson(Map<String, dynamic> json) {
    _sku = json['sku'];
    if (json['collections'] != null) {
      _collections = <Collections>[];
      json['collections'].forEach((v) {
        _collections!.add(Collections.fromJson(v));
      });
     // return ProductItemModel(json['sku'], json['collections']);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sku'] = _sku;
    if (_collections != null) {
      data['collections'] = _collections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Collections {
  String? _title;
  String? _sku;
  String? _image;
  int? _categoryId;
  int? _businessId;
  String? _business;
  String? _link;
  int? _priceNow;

  Collections(
      {String? title,
      String? sku,
      String? image,
      int? categoryId,
      int? businessId,
      String? business,
      String? link,
      int? priceNow}) {
    if (title != null) {
      _title = title;
    }
    if (sku != null) {
      _sku = sku;
    }
    if (image != null) {
      _image = image;
    }
    if (categoryId != null) {
      _categoryId = categoryId;
    }
    if (businessId != null) {
      _businessId = businessId;
    }
    if (business != null) {
      _business = business;
    }
    if (link != null) {
      _link = link;
    }
    if (priceNow != null) {
      _priceNow = priceNow;
    }
  }

  String? get title => _title;
  set title(String? title) => _title = title;
  String? get sku => _sku;
  set sku(String? sku) => _sku = sku;
  String? get image => _image;
  set image(String? image) => _image = image;
  int? get categoryId => _categoryId;
  set categoryId(int? categoryId) => _categoryId = categoryId;
  int? get businessId => _businessId;
  set businessId(int? businessId) => _businessId = businessId;
  String? get business => _business;
  set business(String? business) => _business = business;
  String? get link => _link;
  set link(String? link) => _link = link;
  int? get priceNow => _priceNow;
  set priceNow(int? priceNow) => _priceNow = priceNow;

  Collections.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _sku = json['sku'];
    _image = json['image'];
    _categoryId = json['category_id'];
    _businessId = json['business_id'];
    _business = json['business'];
    _link = json['link'];
    _priceNow = json['price_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = _title;
    data['sku'] = _sku;
    data['image'] = _image;
    data['category_id'] = _categoryId;
    data['business_id'] = _businessId;
    data['business'] = _business;
    data['link'] = _link;
    data['price_now'] = _priceNow;
    return data;
  }
}