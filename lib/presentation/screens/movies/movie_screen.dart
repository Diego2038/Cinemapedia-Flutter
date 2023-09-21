

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;
  
  const MovieScreen({
    super.key,
    required this.movieId
  });

  @override
  ConsumerState createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();
    ref.read( movieInfoProvider.notifier ).loadMovie(widget.movieId);
    ref.read( actorsByMovieProvider.notifier ).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider )[widget.movieId];

    if( movie == null ) {
      return const Scaffold(body: Center( child: CircularProgressIndicator( strokeWidth: 2,)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CustomSliverAppbar(movie: movie),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _MovieDetails(movie: movie),
                childCount: 1 
              ),
            ),
        ]),
    );
  }
}

class _MovieDetails extends StatelessWidget {

  final Movie movie;

  const _MovieDetails({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  width: size.width * 0.3,),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                width: (size.width * 0.7) - 40, 
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Text(movie.title, style: textStyle.titleLarge,),
                    Text( movie.overview),
                ]),
              ),
        
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: movie.genreIds.map((genre) => Container(
              margin: const EdgeInsets.only(right: 10),
              child: Chip(
                label: Text(genre),
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20)),
              ))
            ).toList(),
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString()),
  
        const SizedBox(height: 40,),

      ],
    );
  }
}


class _ActorsByMovie extends ConsumerWidget {

  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch( actorsByMovieProvider);

    if ( actorsByMovie[movieId] == null ) return const CircularProgressIndicator(strokeWidth: 2);

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
    
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(height: 5,),
          
                Text(actor.name, maxLines: 2),
          
                Text(
                  actor.character ?? '', 
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});


class _CustomSliverAppbar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppbar({
    required this.movie
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;
    
    return SliverAppBar(
      actions: [
        IconButton(onPressed: () async{
            // await ref.read( localStorageProvider ).toggleFavorite(movie);
            await ref.read( favoriteMoviesProvider.notifier ).toggleFavorite(movie);
            ref.invalidate( isFavoriteProvider(movie.id));
          }, 
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2,),
            data: ( isFavorite ) => isFavorite
              ? const Icon(Icons.favorite, color: Colors.red,)
              : const Icon(Icons.favorite_border), 
            error: (_,__) => throw UnimplementedError(), 
          )
          
          // const Icon(Icons.favorite_border)
        ),
      ],
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),
        background: Stack(children: [

          SizedBox.expand(
            child: 
              Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if ( loadingProgress != null ) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
          ),

          const _CustomGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1.0],
            colors: [
              Colors.transparent,
              Colors.black87,
            ]
          ),

           const _CustomGradient(
            begin: Alignment.topLeft,
            stops: [0.0, 0.3],
            colors: [
              Colors.black87,
              Colors.transparent,
            ]
          ),

          const _CustomGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0, 0.2],
            colors: [
              Colors.black45,
              Colors.transparent
            ]
          ),

        ]),
      ),
    );
  }
}



class _CustomGradient extends StatelessWidget {

  final AlignmentGeometry begin;
  final AlignmentGeometry? end;
  final List<Color> colors;
  final List<double>? stops;

  const _CustomGradient({
    this.begin = Alignment.centerLeft, 
    this.end, 
    required this.colors, 
    this.stops
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end ?? Alignment.centerRight,
            stops: stops,
            colors: colors
            )
        ),
      ),
    );
  }
}




