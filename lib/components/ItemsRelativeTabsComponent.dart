import 'package:flutter/material.dart';

class ItemsRelativeTabsComponent extends StatefulWidget {
  final String sku; // Parámetro requerido

  const ItemsRelativeTabsComponent({super.key, required this.sku});

  @override
  State<ItemsRelativeTabsComponent> createState() =>
      _ItemsRelativeTabsComponentState();
}

class _ItemsRelativeTabsComponentState
    extends State<ItemsRelativeTabsComponent> {
  @override
  void initState() {
    super.initState();
    _cargarDatosPorSku(widget.sku);
  }

  @override
  void didUpdateWidget(covariant ItemsRelativeTabsComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el SKU cambia (ej. el usuario hace clic en un producto relacionado), volvemos a cargar las listas
    if (oldWidget.sku != widget.sku) {
      _cargarDatosPorSku(widget.sku);
    }
  }

  void _cargarDatosPorSku(String sku) {
    // Aquí puedes disparar tus eventos de Bloc, Providers o llamadas API pasando el sku
    // Ejemplo: context.read<ProductosBloc>().add(FetchProductosRelacionados(sku));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Las 3 pestañas solicitadas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Título de la sección con el icono de etiqueta
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.local_offer_rounded,
                  size: 22,
                  color: Colors.black87,
                ),
                SizedBox(width: 8),
                Text(
                  'Productos Relacionados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // 2. El TabBar con el diseño estilizado e indicador azul
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(
                  25,
                ), // Fondo sutil para la barra de pestañas
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                tabs: [
                  Tab(text: 'Por Categoría'),
                  Tab(text: 'Por Marca'),
                  Tab(text: 'Navegación'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. El TabBarView que renderiza tus componentes de listas existentes
          // Envuelta en un SizedBox con altura fija para evitar desbordamientos en el Sliver
          SizedBox(
            height:
                240, // Ajusta esta altura al tamaño real de tus tarjetas de producto
            child: TabBarView(
              children: [
                /*     // Pestaña 1: Llamas a tu widget enviándole el SKU actual
            ProductRelativesRow(cat: widget.cat, sub: widget.sub, limit: widget.limit),
                // Pestaña 2: Tu componente de marcas
                TuComponenteListadoHorizontalMarca(sku: widget.sku),

                // Pestaña 3: Tu componente de navegación
                TuComponenteListadoHorizontalNavegacion(sku: widget.sku),
            */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
