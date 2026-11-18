import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/helper.dart';
import '../models/Items.dart';

class ItemRowCompareListCompont extends StatelessWidget {
  const ItemRowCompareListCompont({
    super.key,
    required this.items,
    this.onOpen,
  });

  final List<Items> items;
  final void Function(String url)? onOpen;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No hay ofertas disponibles"),
        ),
      );
    }

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return _buildCard(item, index == 0);
      }),
    );
  }

  Widget _buildCard(Items item, bool best) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: best ? 3 : 1,
      color: best ? Colors.green.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// ───── ROW 1: GRID PRINCIPAL ─────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LOGO
                SizedBox(
                  width: 60,
                  child: Image.asset(
                    Helper.getLogoById(item.NegocioID),
                    height: 40,
                  ),
                ),

                const SizedBox(width: 8),

                /// DESCRIPCIÓN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.NegocioNombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: const [
                          _Tag(icon: Icons.local_offer, text: "Promo"),
                          _Tag(icon: Icons.credit_card, text: "Tarjetas"),
                          _Tag(icon: Icons.delivery_dining, text: "Delivery"),
                        ],
                      ),
                    ],
                  ),
                ),

                /// PRECIO
                SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Gs ${NumberFormat.decimalPattern('es_py').format(item.PrecioNuevo)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${item.PrecioOff}% OFF",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(),

            /// ───── BOTÓN ─────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Ir al sitio"),
                onPressed: () {
                  if (onOpen != null) {
                    onOpen!(item.Link);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ───────── TAG REUTILIZABLE ─────────
class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
