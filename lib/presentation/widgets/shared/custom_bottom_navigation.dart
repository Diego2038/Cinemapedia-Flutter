

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  void onItemTapped( BuildContext context, int page ) {
    switch (page) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
      default:
        context.go('/home/0');
        break;
    }
  }

  static int getIndex( BuildContext context ) {
    final String index = GoRouterState.of(context).uri.path;
    return int.parse(index.substring(index.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: getIndex(context),
      elevation: 0,
      onTap: (value) {
        onItemTapped(context, value);
      },
      items: const [
    

        BottomNavigationBarItem(
          icon: Icon( Icons.home_max ),
          label: "Inicio"
        ),

        BottomNavigationBarItem(
          icon: Icon( Icons.label_outline ),
          label: "Categorias"
        ),
        
        BottomNavigationBarItem(
          icon: Icon( Icons.favorite_border_outlined ),
          label: "Favoritos"
        ),

    ]);
  }
}