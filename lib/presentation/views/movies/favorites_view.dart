import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {

  bool isLoading = false;
  bool isLastPage = false;
  
  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    if( isLoading || isLastPage ) return;
    isLoading = true;
    final movies = await ref.read( favoriteMoviesProvider.notifier ).loadNextPage();
    isLoading = false;
    if ( movies.isEmpty ) isLastPage = true;
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();  

    if( favoriteMovies.isEmpty ) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_outlined, size: 65, color: colors.primary,),
            Text("¡Oh no!", style: TextStyle(color: colors.primary, fontSize: 30, fontWeight: FontWeight.bold)),
            const Text(
              "No tienes películas nuevas, aún 😭👌", 
              style: TextStyle(
                color: Colors.black45,
                fontSize: 20
              ),
            ),
            const SizedBox(height: 20,),
            FilledButton.tonal(
              onPressed: () => context.push("/home/0"), 
              child: const Text("Empieza a buscar")
            )
          ]),
      );
    }

    return MovieMasonry(movies: favoriteMovies, loadNextPage: loadMovies,);
  }
}