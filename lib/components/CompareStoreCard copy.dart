import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final radius = BorderRadius.circular(12);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 5,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: bestPrice
                  ? Colors.green
                  : const Color.fromARGB(197, 66, 68, 145),
              width: bestPrice ? 1 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// LOGO
                SizedBox(
                  width: 100,
                  height: 70,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*  if (bestPrice)
                        Center(
                          child: const Text(
                            "MEJOR",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),*/
                      Image.asset(image),
                    ],
                  ),
                ),

                //const SizedBox(width: 16),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$discount% OFF",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Gs. ${NumberFormat.decimalPattern("es_py").format(price)}",
                        ////  "Gs ${price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      /*
                      if (!bestPrice)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "+Gs ${difference.toStringAsFixed(0)} vs mejor precio",
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "El precio más bajo encontrado",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        */
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bestPrice
                        ? Color(0xFF10B981)
                        : const Color.fromARGB(255, 169, 171, 173),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 0,
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => openURL(link),
                  child: const Text(
                    "Ver oferta",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> openURL(String link) async {
    var url = link;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
