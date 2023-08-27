

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {


  @override
  void initState() {
    super.initState();
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

    final slideShowMovies = ref.watch( moviesSlideshowProvider );

    if( slideShowMovies.isEmpty ) return const Center(child: CircularProgressIndicator());

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            centerTitle: false,
            titlePadding: EdgeInsets.zero,
          ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) => Column(
            children: [
        
              // const CustomAppbar(),
              
              MoviesSlideshow(movies: slideShowMovies,),
        
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: "En cines",
                subTitle: "Febrero 31",
                loadNextPage: () => ref.watch( nowPlayingMoviesProvider.notifier ).loadNextPage(),
              ),
        
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: "En cines",
                subTitle: "En este mes",
                loadNextPage: () => ref.watch( nowPlayingMoviesProvider.notifier ).loadNextPage(),
              ),
        
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: "En cines",
                subTitle: "En todos los tiempos",
                loadNextPage: () => ref.watch( nowPlayingMoviesProvider.notifier ).loadNextPage(),
              ),

              const SizedBox(height: 50,)
        
            ],
          ),
          childCount: 1
        ))

      ],
    );
  }
}