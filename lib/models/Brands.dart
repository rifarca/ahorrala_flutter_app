class Brands {
  late int brandId;
  late String brand;
  late String image;
  
  Brands({required this.brandId, required this.brand, required this.image});

  factory Brands.fromJson(Map<String, dynamic> json) {
    return Brands(
    brandId:json['brand_id'],
    brand: json['brand'],
    image:  json['image'],
   
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['brand_id'] = brandId;
    data['brand'] = brand;
    data['image'] = image;
    
    return data;
  }




   factory Brands.fromMap(Map<String, dynamic> map) {
    return Brands(
        brandId: map['brand_id'],
        brand: map['brand'],
        image: map['image'],
        
    );
  }
}