import 'package:ahorrala/helpers/Helper.dart';
import 'package:ahorrala/providers/ConfigProvider.dart';
import 'package:ahorrala/providers/FavoritesProvider.dart';
import 'package:ahorrala/providers/ItemsProvider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late ConfettiController _confetti;

  bool dontShowAgain = false;
  late final configProvider;
  late final favoritesProvider;
  late final itemsLimit;
  late final itemsProvider;
  bool showBottom = true;
  late String? token;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _loadProviders();
    });
    _confetti = ConfettiController(duration: const Duration(seconds: 3));

    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
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

  Future<void> _savePreference() async {
    // SharedPreferences
    //
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('welcome_hidden', dontShowAgain);
  }

  Future<void> _goHome() async {
    // await _savePreference();

    if (!mounted) return;
    context.go("/home");
  }

  Future<void> _goTour() async {
    await _savePreference();

    if (!mounted) return;

    context.push("/tour");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 1,
            top: 1,
            child: Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.6,
                numberOfParticles: 20,
                gravity: 0.2,
              ),
            ),
          ),
          Positioned(
            left: 1,
            top: 1,
            child: Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.6,
                numberOfParticles: 20,
                gravity: 0.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Image.asset(
                  "assets/images/ahorrala_logo_grande.webp",
                  height: 120,
                ),

                const SizedBox(height: 30),

                const Text(
                  "¡Bienvenido a Ahorrala!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Text(
                  "Compará precios entre supermercados, farmacias y tiendas para ahorrar en cada compra.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),

                const SizedBox(height: 40),

                const Text(
                  "¿Querés hacer un recorrido rápido para aprender a usar la aplicación?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 35),

                CheckboxListTile(
                  value: context.read<ConfigProvider>().showWellcomScreen,

                  title: const Text("No volver a mostrar esta pantalla"),

                  onChanged: (v) {
                    context.read<ConfigProvider>().setShowWellcomeScreen(!v!);
                    setState(() {
                      dontShowAgain = !v;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _goHome,

                        child: const Text("Ingresar a la aplicación"),
                      ),
                    ),

                    const SizedBox(width: 15),

                    /* Expanded(
                      child: FilledButton(
                        onPressed: _goTour,

                        child: const Text("Comenzar Tour"),
                      ),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
