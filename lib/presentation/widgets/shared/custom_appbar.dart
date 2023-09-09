


import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegate/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';



class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  final colors = Theme.of( context ).colorScheme;
  final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea( 
      bottom: false,
      child:  Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10 ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              
              Icon(
                Icons.movie_outlined, 
                color: colors.primary, 
              ),
      
              const SizedBox(width: 10,),
      
              Text("Cinemapedia", style: titleStyle,),
      
              const Spacer(),
      
              IconButton(
                onPressed: (){
                  final searchMovies = ref.read(movieRepositoryProvider).searchMovies;
                  showSearch<Movie?>(
                    context: context, 
                    delegate: SearchMovieDelegate(
                      searchMovies: searchMovies
                    )
                  ).then((movie) => context.push('/movie/${movie!.id}'));
                }, 
                icon: const Icon(Icons.search)
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}