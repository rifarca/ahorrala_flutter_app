import 'package:ahorrala/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:ahorrala/providers/ConfigProvider.dart';

class CompareStoreCard extends StatelessWidget {
  final String name;
  final String image;
  final double price;
  final int discount;
  final bool bestPrice;
  final double difference;
  final String link;

  const CompareStoreCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.discount,
    required this.bestPrice,
    required this.difference,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    // El brillo efectivo del tema (System, Dark o Light)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ConfigProvider>(
      builder: (context, config, child) {
        final colorScheme = isDark
            ? AhorralaTheme.darkTheme
            : AhorralaTheme.lightTheme;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),

              decoration: BoxDecoration(
                color: colorScheme.cardColor,

                borderRadius: radius,

                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadowColor.withValues(alpha: .08),
                    blurRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ],

                border: Border.all(
                  color: bestPrice ? Colors.green : Colors.blue,
                  width: 1,
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    /// LOGO
                    SizedBox(
                      width: 100,
                      height: 70,

                      child: Center(
                        child: Image.asset(image, fit: BoxFit.contain),
                      ),
                    ),

                    Flexible(
                      flex: 2,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text(
                            "$discount% OFF",

                            style: TextStyle(
                              color: Colors.red.shade600,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "Gs. ${NumberFormat.decimalPattern("es_py").format(price)}",

                            style: TextStyle(
                              color: Colors.green.shade600,

                              fontSize: 16,

                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bestPrice
                            ? Colors.green.shade600
                            : Colors.blue,

                        foregroundColor: Colors.white,

                        //shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 0,
                        ),

                        elevation: 0,
                      ),

                      onPressed: () => openURL(link),

                      child: const Text(
                        "Ver oferta",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> openURL(String link) async {
    final uri = Uri.parse(link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }
}
