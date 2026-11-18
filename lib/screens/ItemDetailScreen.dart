// ignore_for_file: must_be_immutable

import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:flutter/material.dart';
import 'package:ahorrala/components/ItemCompareListComponent.dart';
import 'package:ahorrala/components/ItemsRelativeByCategoryComponent.dart';
import 'package:ahorrala/components/ProductItemHeaderView.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';

import 'package:ahorrala/components/MenuCrystalBottomNavigationBar.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({
    super.key,
    required this.sku,
    required this.title,
    required this.image,
    required this.category_id,
    required this.category,
  });
  final String title;
  final String sku;
  final String image;
  final int category_id;
  final String category;

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  ///iniciamos nuestro provider
  var provider;
  ScrollController _scrollController = ScrollController();
  bool showBottom = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadScrollerCotroler();
    Future.microtask(() {
      provider = context.read<ItemsProvider>();
      provider.loadItemsCompareBySKU(sku: widget.sku);
      provider.loadItemsRelativeByCategory(sku: widget.sku);
    });
  }

  void _loadScrollerCotroler() {
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showBottom) {
          setState(() => showBottom = false);
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showBottom) {
          setState(() => showBottom = true);
        }
      }
    });
  }

  //aca construimos nuestro widget principal de la pagina
  @override
  Widget build(BuildContext context) {
    /* if (kIsWeb) {
      // Define MetaSEO object
      MetaSEO meta = MetaSEO();
      // add meta seo open graph tags as you want
      // meta.facebookAppID(facebookAppID: 'your_app_id');

      meta.ogTitle(ogTitle: widget.title);
      meta.ogDescription(ogDescription: widget.title);
      meta.ogImage(ogImage: widget.image);

      // here you can add any tags does not exist in the package as this
      meta.nameContent(name: 'title', content: widget.title);

      // or if you want to add twitter card meta tags just as the following
      meta.twitterCard(twitterCard: TwitterCard.summaryLargeImage);
      meta.twitterTitle(twitterTitle: widget.title);
      meta.twitterDescription(twitterDescription: widget.title);
      meta.twitterImage(twitterImage: widget.image);

      // here you can add any tags does not exist in the package as this
      meta.nameContent(name: 'twitter:site', content: 'Ahorrala.com');
    }*/

    return Scaffold(
      extendBody: true,

      // backgroundColor: const Color.fromARGB(255, 253, 253, 254),
      appBar: AppBar(
        //    backgroundColor: Colors.white,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(0),
          child: Text(
            widget.title,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // endDrawer: buildMenuDrawerNavigation(),
      body: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverList.list(
            children: [
              ProductItemHeaderView(
                image: widget.image,
                title: widget.title,

                price: 4000,
                sku: widget.sku,
                category_id: widget.category_id,
                category: widget.category,
              ),

              ItemCompareListComponent(sku: widget.sku),

              ItemsRelativeByCategoryComponent(
                cat: widget.category_id,
                sku: widget.sku,
              ),
              SizedBox(width: double.infinity, height: 140),
            ],
          ),
        ],
      ),
      bottomNavigationBar: context.read<ConfigProvider>().autoHideBottomBar
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: showBottom ? Offset.zero : const Offset(0, 2),
              child: MenuCrystalBottomNavigationBar(selectedItem: 0),
            )
          : MenuCrystalBottomNavigationBar(selectedItem: 0),
    );
  }
}
