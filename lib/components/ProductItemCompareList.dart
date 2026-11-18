// ignore_for_file: prefer_is_empty, unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/helper.dart';
import '../models/Items.dart';

class ProductItemCompareList extends StatefulWidget {
  const ProductItemCompareList({super.key, required this.sku});
  final String sku;

  @override
  _ProductItemCompareListState createState() => _ProductItemCompareListState();
}

class _ProductItemCompareListState extends State<ProductItemCompareList> {
  late int totalItems = 0;

  String msg = "";
  Future<void> getItemsCompareToptal(String sku) async {
    //_loadAdIntertistial();
    var data = await Helper.getItemsCompare(sku);

    setState(() {
      if (data.isNotEmpty) {
        totalItems = data.length;
      } else {
        totalItems = 0;
      }

      if (totalItems == 1) {
        msg = '$totalItems oferta encontrada..';
      } else if (totalItems > 1) {
        msg = '$totalItems ofertas encontradas..';
      } else if (totalItems == 0) {
        msg = 'No hay ofertas para este producto..';
      }
    });
  }

  @override
  void initState() {
    getItemsCompareToptal(widget.sku);
    super.initState();
  }

  Future<void> openURL(String link) async {
    var url = link;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildItem(Items item, {bool bestPrice = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: bestPrice ? 3 : 1,
      color: bestPrice ? Colors.green.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Logo + Nombre supermercado
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(Helper.getLogoById(item.NegocioID), height: 40),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    item.NegocioNombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                if (bestPrice)
                  const Chip(
                    avatar: Icon(
                      Icons.workspace_premium,
                      size: 18,
                      color: Colors.amber,
                    ),
                    label: Text("Mejor precio"),
                  ),
              ],
            ),

            const SizedBox(height: 0),

            /// Precio
            Text(
              "Gs ${NumberFormat.decimalPattern('es_py').format(item.PrecioNuevo)}",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            /// Descuento
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "${item.PrecioOff}% OFF",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text("Comprar"),
                onPressed: () => openURL(item.Link),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
        body: */ Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        /* const DecoratedBox(
          decoration: BoxDecoration(),
          child: SizedBox(
            height: 2,
            width: 20,
            child: ColoredBox(color: Color.fromARGB(255, 68, 21, 155)),
          ),
        ),*/
        FutureBuilder<List<Items>>(
          future: Helper.getItemsCompare(widget.sku),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.grey),
              );
            } else {
              if (snapshot.data?.length == 0) {
                return const Center(child: Text('No hay datos'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildItem(
                        snapshot.data![index],
                        bestPrice: index == 0,
                      );
                      /*
                      if (index < snapshot.data!.length) {
                        if (index == 0) {
                          return Card(
                            margin: EdgeInsets.all(0),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0.3,
                            // color: const Color.fromARGB(255, 255, 255, 255),
                            child:/*0ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /*Text(
                                      snapshot.data![index].NegocioNombre,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),*/
                                  Image.asset(
                                    Helper.getLogoById(
                                      snapshot.data![index].NegocioID,
                                    ),
                                    height: 40,
                                  ),
                                  Text(''),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(' '),
                                  Text(
                                    '${snapshot.data![index].PrecioOff}% OFF',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        221,
                                        4,
                                        4,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(' '),
                                  Text(
                                    'Gs ${NumberFormat.decimalPattern('es_py').format(snapshot.data![index].PrecioNuevo)}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        2,
                                        126,
                                        29,
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                style: ButtonStyle(
                                  elevation: WidgetStatePropertyAll(2),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.green,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  var url = snapshot.data![index].Link
                                      .toString();
                                  openURL(url);
                                },
                                child: Text(
                                  'Comprar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),*/
                            
                          );
                        } else {
                          if (index % 2 == 0) {
                            return Card(
                              margin: EdgeInsets.all(0),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0.1,
                              // color: const Color.fromARGB(255, 255, 254, 254),
                              child: ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Helper.getLogoById(
                                        snapshot.data![index].NegocioID,
                                      ),
                                      height: 40,
                                    ),
                                    /* Text(
                                        snapshot.data![index].NegocioNombre,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )*/
                                    Text(''),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(' '),
                                    Text(
                                      '${snapshot.data![index].PrecioOff}% OFF',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          221,
                                          4,
                                          4,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(' '),
                                    Text(
                                      'Gs ${NumberFormat.decimalPattern('es_py').format(snapshot.data![index].PrecioNuevo)}',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          2,
                                          126,
                                          29,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                //boton ver ofervta o comprar
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    var url = snapshot.data![index].Link
                                        .toString();
                                    openURL(url);
                                  },
                                  child: Text('Comprar'),
                                ),
                              ),
                            );
                          } else {
                            return Card(
                              margin: EdgeInsets.all(0),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(8),
                              ),

                              elevation: .1,
                              // color: const Color.fromARGB(255, 255, 255, 255),
                              child: ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Helper.getLogoById(
                                        snapshot.data![index].NegocioID,
                                      ),
                                      height: 40,
                                    ),

                                    /*Text(
                                        snapshot.data![index].NegocioNombre,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),*/
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(' '),
                                    Text(
                                      '${snapshot.data![index].PrecioOff}% OFF',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          221,
                                          4,
                                          4,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(' '),
                                    Text(
                                      'Gs ${NumberFormat.decimalPattern('es_py').format(snapshot.data![index].PrecioNuevo)}',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          2,
                                          126,
                                          29,
                                        ),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    var url = snapshot.data![index].Link
                                        .toString();
                                    openURL(url);
                                  },
                                  child: Text('Comprar'),
                                ),
                              ),
                            );
                          }
                        }
                      }
                      return const Center(child: Text('Cargando'));*/
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Color.fromARGB(255, 188, 207, 244),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ],
    );
    //);
  }
}
