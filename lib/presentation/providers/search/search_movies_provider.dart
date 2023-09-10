import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final searchQueryProvider = StateProvider<String>((ref) => "");

final searchMoviesProvider = StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read( movieRepositoryProvider);
  return SearchMoviesNotifier(
    searchMovieCallback: movieRepository.searchMovies,
    ref: ref
  );
});

typedef SearchMovieCallback = Future<List<Movie>> Function({required String query});

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {

  final SearchMovieCallback searchMovieCallback;
  final Ref ref;

  SearchMoviesNotifier({
    required this.searchMovieCallback,
    required this.ref
  })
    :super([]);

  Future<List<Movie>> getSearchMoviesByQuery ({required String query}) async {
    ref.read( searchQueryProvider.notifier).state = query;
    final movies = await searchMovieCallback(query: query);
    state = movies;
    return movies;
  } 

}