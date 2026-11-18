import 'package:flutter/material.dart';

import '../services/FavoritesServices.dart';


class FavoritesProvider extends ChangeNotifier {


  final FavoritesServices service;


  FavoritesProvider(
    this.service
  );


  List<String> _skus = [];


  List<String> get skus => _skus;


  int get count => _skus.length;



  Future<void> init() async {

    await service.init();

    _skus = service.getSkus();

    notifyListeners();

  }



  bool isFavorite(String sku){

    return _skus.contains(sku);

  }



  Future<void> toggle(String sku) async {


    final value =
      await service.toggle(sku);


    if(value){

      _skus.add(sku);

    }else{

      _skus.remove(sku);

    }


    notifyListeners();

  }



  Future<void> remove(String sku) async {


    await service.remove(sku);


    _skus.remove(sku);


    notifyListeners();

  }



}