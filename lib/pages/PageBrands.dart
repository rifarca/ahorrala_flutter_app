import '../helpers/helper.dart';
import '../models/Brands.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../components/BrandItemGrid.dart';
import '../components/ShimmerePlaceHolder.dart';

class PageBrands extends StatefulWidget {
  const PageBrands({super.key, required this.title});
  final String title;

  @override
  State<PageBrands> createState() => _PageBrandsState();
}

class _PageBrandsState extends State<PageBrands> {
  @override
  void initState() {
    super.initState();

    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var grids = 2;
    if (kIsWeb) {
      grids = 4;
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<Brands>>(
        future: getBrandsList(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grids,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: const Color.fromARGB(255, 245, 245, 245),
                      enabled: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BannerPlaceholder(),
                          TitlePlaceholder(width: double.infinity),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            if (snapshot.data?.length == 0) {
              return CircularProgressIndicator();
            } else {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 3.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < snapshot.data!.length) {
                      return BranditemGrid(
                        marca_id: snapshot.data![index].brandId,
                        marca: snapshot.data![index].brand,
                        imagen: snapshot.data![index].image,
                        onTap: () {
                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageItemsXCategory(
                                      categoria_id:snapshot.data![index].id,
                                      categoria: snapshot.data![index].name, 
                                      imagen: '',
                                  ))
                                      ); */
                          //  Brands cat = Brands(id: snapshot.data![index].id, name: snapshot.data![index].name, image: snapshot.data![index].image, items: 0, subs: 0);
                          // context.push("/categorias/${snapshot.data![index].id}",extra: cat);
                        },
                      );
                    }
                    return ContentPlaceholder(
                      lineType: ContentLineType.threeLines,
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Brands>> getBrandsList() async {
    final data = await Helper.getBrandsList();
    return data;
  }
}
