// ignore_for_file: unused_element
import 'package:ahorrala/components/MenuNeoGlassNaviogator.dart';
import 'package:flutter/material.dart';

import 'package:ahorrala/helpers/Helper.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_welcome_kit/flutter_welcome_kit.dart';

import 'package:provider/provider.dart';

import '../components/ItemsByCategoryListComponent.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //late final authProvider;
  bool auto_hide_bottom_bar = true;
  late final configProvider;
  late final favoritesProvider;
  late final itemsLimit;
  late final itemsProvider;
  bool showBottom = true;
  late String? token;

  late ScrollController _scrollController;
  final stepKey1 = GlobalKey();
  final stepKey2 = GlobalKey();
  final stepKey3 = GlobalKey();
  late TourController _tourController;
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadScrollerCotroler();
    // Encadenamos el Tour de manera secuencial para que ocurra
    // JUSTO DESPUÉS de que terminen de cargar todos tus proveedores de datos.
     Future.microtask(() async {
      await _loadProviders();
    });
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadHomeTour(context);
    //});
    // Cargamos el historial al iniciar la pantalla
  }

  Widget ItemsByCategorySection(int categoryId) {
    return ItemsByCategoryListComponent(cat: categoryId, sub: 1, limit: 16);
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

  // Eliminamos los "await" incorrectos sobre context.read (que no devuelve un Future)
  Future<void> _loadProviders() async {
    itemsProvider = context.read<ItemsProvider>();
    configProvider = context.read<ConfigProvider>();
    favoritesProvider = context.read<FavoritesProvider>();

    await configProvider.load();

    // Corrección: Usar setState si alteras propiedades de la clase que impactan la UI
    final autoHide = await configProvider.autoHideBottomBar;
    final totalResults = await configProvider.itemsResultsTotal;

    setState(() {
      showBottom = autoHide;
      itemsLimit = totalResults;
    });

    await itemsProvider.loadItemsByCategory(
      categoryId: 6,
      sub: 1,
      limit: itemsLimit,
    );
    await itemsProvider.loadItemsByCategory(
      categoryId: 2,
      sub: 1,
      limit: itemsLimit,
    );
    await itemsProvider.loadItemsByCategory(
      categoryId: 7,
      sub: 1,
      limit: itemsLimit,
    );
    await itemsProvider.loadItemsByCategory(
      categoryId: 3,
      sub: 1,
      limit: itemsLimit,
    );
    await itemsProvider.loadItemsByCategory(
      categoryId: 5,
      sub: 1,
      limit: itemsLimit,
    );
    await itemsProvider.loadItemsByCategory(
      categoryId: 4,
      sub: 1,
      limit: itemsLimit,
    );
    await itemsProvider.loadItemsByCategory(
      categoryId: 10,
      sub: 1,
      limit: itemsLimit,
    );

    await itemsProvider.loadItemsFavorites(
      favoritesProvider.skus,
      forceRefresh: false,
    );
    Helper.obtenerDatosControl();
  }

  void _loadHomeTour(BuildContext ctx) {
    // 2. Create the tour controller
    _tourController = TourController(
      dontShowAgainText: "No volver a mostrar",
      context: ctx,
      steps: [
        TourStep(
          key: stepKey1,

          title: 'Menu Sencillo',
          description:
              'Navegacion de la App, Ahorrala, preseta por el moento 5 efectivos screen',
          backgroundColor: Colors.white,
          spotlightPadding: 25,
          showPulse: true,
        ),
        TourStep(
          key: stepKey2,
          title: '',
          description: 'Cada Boyon te llevara una Pantalla o Screen diferene',
          backgroundColor: const Color.fromARGB(255, 214, 238, 239),
          highlightShape: HighlightShape.rounded,
          showPulse: true,
          isLast: true,
        ),
      ],
      onComplete: () => print('Tour finished!'),
      onSkip: () => print('Tour skipped'),
    );

    // 3. Start the tour
    _tourController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: _PersistenHeaderDelegate(),
            pinned: true,
            floating: false,
          ),

          Container(
            child: SliverList(
              delegate: SliverChildListDelegate([
                Container(key: stepKey2, child: ItemsByCategorySection(6)),
                ItemsByCategorySection(2),
                ItemsByCategorySection(7),
                ItemsByCategorySection(3),
                ItemsByCategorySection(5),
                ItemsByCategorySection(4),
                ItemsByCategorySection(10),
                SizedBox(height: 140),
              ]),
            ),
          ),
          /*SliverToBoxAdapter(
            child: Column(
              children: [
                ItemsByCategorySection(6),
      
                ItemsByCategorySection(2),
      
                ItemsByCategorySection(7),
      
                ItemsByCategorySection(3),
      
                ItemsByCategorySection(5),
      
                ItemsByCategorySection(4),
      
                ItemsByCategorySection(10),
                SizedBox(width: double.infinity, height: 140),
              ],
            ),
          ),*/
        ],
      ),

      bottomNavigationBar: context.read<ConfigProvider>().autoHideBottomBar
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: showBottom ? Offset.zero : const Offset(0, 2),
              child: MenuNeoGlassNavigationBar(
                key: stepKey1,
                selectedItem: 0,
              ),
            )
          : MenuNeoGlassNavigationBar(key: stepKey1, selectedItem: 0),
    );
  }
}

final _maxHeaderSliver = 250;
final _minHeaderSliver = 100;

class _PersistenHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 250;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double progress = (shrinkOffset / (maxExtent - minExtent)).clamp(
      0.0,
      1.0,
    );

    final double logoSize = 250 - (170 * progress);

    final double logoLeft =
        (MediaQuery.of(context).size.width / 2 - 125) -
        ((MediaQuery.of(context).size.width / 2 - 135) * progress);

    return SizedBox(
      height: maxExtent, // IMPORTANTE
      width: double.infinity,

      child: Material(
        elevation: 2,

        child: Stack(
          fit: StackFit.expand,

          children: [
            Opacity(
              opacity: 1 - progress,

              child: Image.asset(
                'assets/images/parallax.png',
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              left: logoLeft,
              top: 0 + (30 * progress),

              child: Image.asset(
                'assets/images/ahorrala_logo_grande.webp',
                width: logoSize,
                height: logoSize,
              ),
            ),

            Positioned(
              right: 20,
              top: 50,

              child: Opacity(
                opacity: progress,

                child: const Text(
                  "Ahorrala",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
