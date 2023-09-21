

import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';
  final int page;

  const HomeScreen({
    super.key,
    required this.page
  });

  final screens = const [
    HomeView(),
    SizedBox(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: page,
        children: screens,
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

