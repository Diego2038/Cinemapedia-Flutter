

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function ({required String query});

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  SearchMoviesCallback searchMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies
  });

  @override
  String get searchFieldLabel => "Buscar película"; 

  void clearStreams() {
    debounceMovies.close();
  }

  void _onQueryChanged( String query ) {
    print("queryString changed");
    if( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();
    _debounceTimer = Timer( const Duration(milliseconds: 500), () async {
      if ( query.isEmpty ) {
        debounceMovies.add([]);
        return;
      }
      print("searching movies");
      final movies = await searchMovies(query: query);
      debounceMovies.add(movies);
    },);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // if (  query.isNotEmpty )
        FadeIn(
          animate: query.isNotEmpty,
          duration: const Duration(milliseconds: 300),
          child: IconButton(
            onPressed: () => query = "", 
            icon: const Icon(Icons.clear)
          ),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("Build results");
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return StreamBuilder(
      // future: searchMovies( query: query),
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        //! TODO: print(" Realizando petición de búsqueda...");
        final movies = snapshot.data ?? [];

        return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _MovieItem(
            movie: movies[index],
            searchForCallback: (BuildContext context, Movie? movie) {
              clearStreams();
              close(context, movie);
            },
          );
        }
        );
      },
    );
  }

}

typedef SearchMovieCallback = void Function( BuildContext, Movie? );

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final SearchMovieCallback searchForCallback;

  const _MovieItem({
     required this.movie, 
     required this.searchForCallback
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: () {
          searchForCallback(context, movie );
        },
        child: Row( children: [
      
          // Image
          SizedBox( 
            width: size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath == 'no-poster'
                  ? "https://www.movienewz.com/wp-content/uploads/2014/07/poster-holder.jpg"
                  : movie.posterPath,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null ) return const SizedBox.shrink(); 
                  return FadeIn(child: child);
                },
              ),
            ),
          ),
      
          // Description
      
          const SizedBox(width: 10,),
      
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
      
                Text( 
                  movie.title,
                  style: textStyle.titleMedium,
                ),
                
                Text( 
                  movie.overview.length > 100 
                    ? '${movie.overview.substring(0,100)}...' 
                    : movie.overview
                ),
      
                const SizedBox(height: 5,),
      
                Row(
                  children: [
      
                    Icon(Icons.star_border_outlined, color: Colors.yellow.shade800,),
                    const SizedBox(width: 5,),
                    Text( 
                      HumanFormats.number(movie.voteAverage, 1),
                      style: textStyle.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                    ),
      
                  ],
                ),
              ],
            ),
          ),
      
        ],),
      ),
    );
  }
}