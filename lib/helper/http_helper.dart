import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mp_uas/model/movie.dart';

class HttpHelper {
  final String urlBase = 'https://api.themoviedb.org/3/';
  final String urlLanguage = 'language=en-US';
  final String urlKey = 'api_key=KEY_HERE';
  final String urlUpcoming = 'movie/upcoming';
  final String urlSearch = 'search/movie';
  final String urlTopRated = 'movie/top_rated';

  Future<String> getUpcoming() async {
    final Uri upcoming = Uri.parse('$urlBase$urlUpcoming?$urlKey&$urlLanguage');
    http.Response result = await http.get(upcoming);
    if (result.statusCode == HttpStatus.ok) {
      String responseBody = result.body;
      return responseBody;
    } else {
      return '{}';
    }
  }

  Future<List> getUpcomingAsList() async {
    final Uri upcoming = Uri.parse('$urlBase$urlUpcoming?$urlKey&$urlLanguage');
    http.Response result = await http.get(upcoming);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponseBody = json.decode(result.body);
      final movieObjects = jsonResponseBody['results'];
      List movies = movieObjects.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      return [];
    }
  }

  Future<List> getTopRatedAsList() async {
    final Uri topRated = Uri.parse('$urlBase$urlTopRated?$urlKey&$urlLanguage');
    http.Response result = await http.get(topRated);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponseBody = json.decode(result.body);
      final movieObjects = jsonResponseBody['results'];
      List movies = movieObjects.map((json) => Movie.fromJson(json)).toList();
      return movies;
    } else {
      return [];
    }
  }

  Future<List> findMovies(String title) async {
    final Uri query =
        Uri.parse(('$urlBase$urlSearch?$urlKey&$urlLanguage&query=$title'));
    http.Response hasilCari = await http.get(query);
    if (hasilCari.statusCode == HttpStatus.ok) {
      final jsonReponseBody = json.decode(hasilCari.body);
      final movieObjects = jsonReponseBody['results'];
      List movies = movieObjects.map((json) => Movie.fromJson(json)).toList();

      return movies;
    } else {
      return [];
    }
  }
}
