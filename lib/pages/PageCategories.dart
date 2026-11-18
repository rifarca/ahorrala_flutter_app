import '../components/CategoryItemGrid.dart';
import '../components/MenuBottomNavigationBar.dart';
import '../helpers/helper.dart';
import '../models/Categories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../components/ShimmerePlaceHolder.dart';

class PageCategories extends StatefulWidget {
  const PageCategories({super.key, required this.title});
  final String title;

  @override
  State<PageCategories> createState() => _PageCategoriesState();
}

class _PageCategoriesState extends State<PageCategories> {
  @override
  void initState() {
    super.initState();
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _.requestFocus();
    });*/
  }

  @override
  @override
  Widget build(BuildContext context) {
    var grids = 2;
    if (kIsWeb) {
      grids = 4;
    }
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 217, 225, 252),
      appBar: AppBar(title: Text(widget.title)),
      body:
          //endDrawer: buildMenuDrawerNavigation(),
          FutureBuilder<List<Categories>>(
            future: getCategoriesList(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: grids,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                    ),
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: const Color.fromARGB(
                            255,
                            245,
                            245,
                            245,
                          ),
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
                  return Column(
                    children: [
                      BannerPlaceholder(),
                      BannerPlaceholder(),
                      BannerPlaceholder(),
                      BannerPlaceholder(),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: grids,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 3.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < snapshot.data!.length) {
                          return CategoryitemGrid(
                            categoria_id: snapshot.data![index].id,
                            categoria: snapshot.data![index].name,
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
                              Categories cat = Categories(
                                id: snapshot.data![index].id,
                                name: snapshot.data![index].name,
                                image: snapshot.data![index].image,
                                items: 0,
                                subs: 0,
                              );
                              context.push(
                                "/categorias/${snapshot.data![index].id}",
                                extra: cat,
                              );
                            },
                          );
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.white12,
                          highlightColor: Colors.grey.shade300,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            },
          ),
      bottomNavigationBar: MenuBottomNavigationBar(item: 1),
    );
  }

  Future<List<Categories>> getCategoriesList() async {
    var data = await Helper.getCategoriesList();
    return data;
  }
}
