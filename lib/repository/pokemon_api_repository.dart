import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class PokemonApiRepository {

  final Logger _logger;
  final _baseUrl = "https://pokeapi.co/api/v2/pokemon";

  PokemonApiRepository(this._logger);

  Future<Map<String, dynamic>> getNames() async {
    try {
      var response = await http.get(Uri.parse("$_baseUrl/?offset=0&limit=999999"));
      return json.decode(response.body) as Map<String, dynamic>;
    }
    catch (e) {
      _logger.e(e);
      rethrow;
    }
  }

  getDetails(String name) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/$name"));
      return json.decode(response.body) as Map<String, dynamic>;
    }
    catch (e) {
      _logger.e(e);
      rethrow;
    }
  }
}