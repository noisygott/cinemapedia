

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasource{

  final dio = Dio(BaseOptions(
    baseUrl: 'http://api.themoviedb.org/3',
    queryParameters: {
      'api_key' : Environment.theMovieDbKey,
      'language' : 'es-MX'
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    final response = await dio.get('/movie/now_playing');

    final movieDBResponse = MovieDbResponse.fromJson(response.data);


    final List<Movie> movies = movieDBResponse.results
    .where((movieDB) => movieDB.posterPath != 'no-poster')
    .map(
      (e) => MovieMapper.movieDbToEntity(e),
    ).toList();

    return movies;
  }
}