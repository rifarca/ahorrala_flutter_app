// ignore_for_file: prefer_is_empty, unused_element
import 'package:ahorrala/components/SimpleAnimationComponent.dart';
import 'package:flutter/material.dart';

import 'CompareStoreCard.dart';

import 'package:url_launcher/url_launcher.dart';

import 'ShimmerePlaceHolder.dart';

import '../helpers/helper.dart';
import '../models/Items.dart';

class ItemCompareListComponent extends StatefulWidget {
  const ItemCompareListComponent({
    super.key,
    required this.sku,
    required List<Items> items,
  });
  final String sku;

  @override
  _ItemCompareListComponentState createState() =>
      _ItemCompareListComponentState();
}

class _ItemCompareListComponentState extends State<ItemCompareListComponent> {
  late Future<List<Items>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = Helper.getItemsCompare(widget.sku);
  }

  @override
  void didUpdateWidget(covariant ItemCompareListComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sku != widget.sku) {
      _itemsFuture = Helper.getItemsCompare(widget.sku);
    }
  }

  Future<void> openURL(String link) async {
    final url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Items>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        String statusMessage = 'Buscando ofertas...';
        Widget content = const Center(
          child: Row(
            children: [
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
            ],
          ),
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          statusMessage = 'Buscando ofertas...';
        } else if (snapshot.hasError) {
          statusMessage = 'Error al cargar ofertas..';
          content = Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          statusMessage = 'No hay ofertas para este producto..';
          content = const Center(child: Text('No hay datos'));
        } else {
          final items = snapshot.data!;
          final totalItems = items.length;
          statusMessage = totalItems == 1
              ? 'disponible en ..'
              : 'Disponible en $totalItems negocios ..';
          content = Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return SimpleAnimationComponent(
                  duration: Duration(milliseconds: 800),
                  effects: [AnimationEffect.fadeIn, AnimationEffect.flipX],
                  child: CompareStoreCard(
                    name: item.NegocioNombre,
                    image: Helper.getLogoById(item.NegocioID),
                    bestPrice: index == 0,
                    price: item.PrecioNuevo.toDouble(),
                    discount: item.PrecioOff,
                    difference: 0,
                    link: item.Link,
                  ),
                );
              },
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,

                  ///fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            content,
          ],
        );
      },
    );
  }
}
