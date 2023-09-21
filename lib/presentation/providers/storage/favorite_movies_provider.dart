

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider = StateNotifierProvider<StorageNotifierProvider, Map<int,Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageProvider);
  return StorageNotifierProvider( localStorageRepository: localStorageRepository );
});

class StorageNotifierProvider extends StateNotifier<Map<int,Movie>> {

  LocalStorageRepository localStorageRepository;
  int page = 0;

  StorageNotifierProvider({
    required this.localStorageRepository
  }): super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 15); // Limit 20
    page++;

    final tempMoviesMap = <int,Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap}; 
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    final movieFavorite = state[movie.id];
    if ( movieFavorite != null ) {
      state.remove( movie.id );
      state = { ...state };
    } else {
      state = { movie.id: movie, ...state};
    }
  }

}