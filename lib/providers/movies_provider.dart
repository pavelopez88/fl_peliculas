import 'dart:async';

import 'package:fl_peliculas/helpers/debouncer.dart';
import 'package:fl_peliculas/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MoviesProvider extends ChangeNotifier{

  final String _apiKey = 'ab6658d81d3a259ee8ff09bb4ef78e81';
  final String _baseUrl = 'api.themoviedb.org';
  final String _languaje = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCast = {};
  int _popularPage = 0;


  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500), 
  );
  final StreamController<List<Movie>> _suggestionsStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionsStreamController.stream;

  MoviesProvider() {
    print('Movies Povider init');
    getOnDisplayMovies();
    getPopularMovies();

  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url =
      Uri.https(_baseUrl, endpoint, {
          'api_key' : _apiKey,
          'language' : _languaje,
          'page' : '$page'
        }
      );

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    
    // Await the http get response, then decode the json-formatted response.
    final response = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowplayingResponse.fromJson(response);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();

  }

  getPopularMovies() async {
    _popularPage++;
    // Await the http get response, then decode the json-formatted response.
    final response = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(response);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if ( movieCast.containsKey(movieId) ) return movieCast[movieId]!;

    print("CAST");

    final response = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(response);
    movieCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url =
      Uri.https(_baseUrl, '3/search/movie', {
          'api_key' : _apiKey,
          'language' : _languaje,
          'query' : query
        }
      );

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovie(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value =  query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

}