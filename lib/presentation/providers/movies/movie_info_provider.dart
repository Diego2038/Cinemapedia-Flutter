


import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String,Movie>>((ref) {
  final movieRepository = ref.watch( movieRepositoryProvider );
  return MovieMapNotifier(getMovieCallback: movieRepository.getMovieById );
});

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String,Movie>>{

  final GetMovieCallback getMovieCallback;

  MovieMapNotifier({
    required this.getMovieCallback
  }): super({});

  Future<void> loadMovie( String movieId ) async {
    if( state[movieId] != null ) return;
    // print("Realizando petición HTTP");
    final movie = await getMovieCallback(movieId);

    state = {...state, movieId: movie };
  }
  
}