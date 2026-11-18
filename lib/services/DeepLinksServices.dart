import 'package:ahorrala/helpers/helper.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'RoutesServices.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  Future<void> init() async {
    // App abierta desde link
    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      _handleUri(initialUri);
    }

    // App ya abierta
    _subscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleUri(uri);
      },
      onError: (error) {
        debugPrint("DeepLink error: $error");
      },
    );
  }

  Future<void> _handleUri(Uri uri) async {
    debugPrint("======================");
    debugPrint("DEEP LINK:");
    debugPrint(uri.toString());
    debugPrint("======================");
    debugPrint("DeepLink recibido: $uri");

    final path = uri.path;

    if (path.startsWith('/items/') || path.startsWith('/item/')) {
      final sku = path.split('/').last;
      final provider = ItemsProvider();
      await provider.loadItemsCompareBySKU(sku: sku);
      final item = provider.getItemsCompareBySKU(sku);
      router.push('/items/$sku', extra: item[0]);
    } else if (path.startsWith('/categoria/') ||
        path.startsWith('/categorias/')) {
      var id = path.split('/').last;
      // ignore: unused_local_variable

      final category = Helper.getCategoryByID(int.parse(id));
      router.push('/categorias/$id', extra: category);
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
