import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:go_router/go_router.dart';

//Componente Menu de NAvegacion q
class MenuBottomNavigationBar extends StatefulWidget {
  const MenuBottomNavigationBar({super.key, required this.item});
  final int item;
  @override
  // ignore: library_private_types_in_public_api
  _MenuBottomNavigationBarState createState() =>
      _MenuBottomNavigationBarState();
}

class _MenuBottomNavigationBarState extends State<MenuBottomNavigationBar> {
  int selecteditem = 0;
  String? _scannedValue;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      selecteditem = index;
    });

    switch (selecteditem) {
      case 0:
        if (selecteditem != widget.item) {
          context.go('/');

          break;
        }
        break;
      case 1:
        if (selecteditem != widget.item) {
          context.push('/categorias');
          break;
        }
        break;
      case 2:
        if (selecteditem != widget.item) {
          context.push('/favoritos');

          break;
        }
        break;
      case 3:
        if (selecteditem != widget.item) {
          context.push('/buscar');

          break;
        }
        break;
      case 4:
        if (selecteditem != widget.item) {
          context.push('/config');

          break;
        }
        break;
      /*case 3:
        if (selecteditem != widget.item) {
          context.go('/');

          break;
        }
        break;
      case 4:
        if (selecteditem != widget.item) {
          context.go('/login');

          break;
        }
        break;*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      useLegacyColorScheme: true,
      backgroundColor: Colors.white,
      selectedItemColor: const Color.fromARGB(255, 11, 96, 6), // Colors.black,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      unselectedItemColor: const Color.fromARGB(255, 60, 60, 60),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      enableFeedback: true,
      currentIndex: widget.item,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SFIcon(SFIcons.sf_house),
          activeIcon: SFIcon(SFIcons.sf_house_fill),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: SFIcon(SFIcons.sf_square_2_layers_3d),
          activeIcon: SFIcon(SFIcons.sf_square_2_layers_3d_fill),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outlined),
          activeIcon: Icon(Icons.favorite),

          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          activeIcon: Icon(CupertinoIcons.search_circle_fill),

          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.gear_alt),
          activeIcon: Icon(CupertinoIcons.gear_alt_fill),

          label: 'Opciones',
        ) /*
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.tag_solid),R
          label: 'Catalogo',
        ),

        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_fill),
          label: 'Perfil',
        ),*/,
      ],
    );
  }
}
