



import 'package:cinemapedia/infraestructure/datasource/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infraestructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsRepositoryProvider = Provider((ref)  { 
  return ActorRepositoryImpl(ActorMoviedbDatasource());
});