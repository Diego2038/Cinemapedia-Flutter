
 
import 'package:cinemapedia/infraestructure/datasource/moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider((ref){
  return MovieRepositoryImpl(MoviesdbDatasource());
});
 
 
