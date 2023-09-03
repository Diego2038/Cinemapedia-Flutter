

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
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
    ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final isLoadingData = ref.watch( initialLoadingProvider );

    if( isLoadingData ) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );

    final slideShowMovies = ref.watch( moviesSlideshowProvider );

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
                movies: popularMovies,
                title: "Populares",
                loadNextPage: () => ref.watch( popularMoviesProvider.notifier ).loadNextPage(),
              ),
        
              MovieHorizontalListview(
                movies: upcomingMovies,
                title: "Próximamente",
                loadNextPage: () => ref.watch( upcomingMoviesProvider.notifier ).loadNextPage(),
              ),

              MovieHorizontalListview(
                movies: topRatedMovies,
                title: "Top rated",
                subTitle: "En todos los tiempos",
                loadNextPage: () => ref.watch( topRatedMoviesProvider.notifier ).loadNextPage(),
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