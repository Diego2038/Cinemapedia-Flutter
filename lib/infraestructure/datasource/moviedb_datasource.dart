

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/movie_datails.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviesdbDatasource extends MoviesDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: "https://api.themoviedb.org/3/",
    queryParameters: {
      "api_key": Environment.theMovieDbKey,
      "language": 'es-MX'
    }
  )
  );

  List<Movie> _jsonToMovies(Map<String,dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json).results;

    final List<Movie> movies = movieDbResponse
      .where((moviedb) => moviedb.posterPath != 'no-poster')
      .map((movieResponse) => MovieMapper.movieDBtoEntity(movieResponse)).toList();
    
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('movie/now_playing',
      queryParameters: {
        'page': page,
      }
    ); 

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async  {
    final response = await dio.get(
      'movie/popular',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      'movie/top_rated',
      queryParameters:  {
        'page': page
      }
    );

    return _jsonToMovies( response.data );
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      'movie/upcoming',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies( response.data );
  }
  
  @override
  Future<Movie> getMovieById(String id) async{
    final response = await dio.get(
      'movie/$id');
    
    if ( response.statusCode != 200 ) throw Exception("Movie with id: $id not found");

    final movieDetails = MovieDetails.fromJson(response.data);
    final movie = MovieMapper.movieDetailsToEntity( movieDetails );
    return movie ;
  }
  
  @override
  Future<List<Movie>> searchMovies({required String query}) async {
    if ( query.trim().isEmpty) return [];
    final response = await dio.get("search/movie",
      queryParameters: {
        "query": query
      }
    );
    
    return _jsonToMovies(response.data);
  }

}