import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonProvider with ChangeNotifier {

  final _baseUrl = "https://pokeapi.co/api/v2/pokemon";

  List<String> pokemonNames = [];
  late Pokemon details;

  Future<void> getNames() async {
    try {
      Uri url = Uri.parse("$_baseUrl/?offset=0&limit=999999");
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      pokemonNames = [];
      for (var element in (responseData['results'] as List)) {
        element as Map<String, dynamic>;
        var name = element['name'] as String;
        pokemonNames.add(name);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Future<List<Pokemon>> getSavedPokemons() async {
  //
  // }
  //

  Future<Pokemon> getDetails(String name) async {

    try {
      Uri url = Uri.parse("$_baseUrl/$name");
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      String id = responseData['id'].toString();
      details = Pokemon(
          id: id,
          name: responseData['name'],
          sprite: responseData['sprites']['front_default'],
          type1: responseData['types'][0]['type']['name'],
          type2: responseData.length == 2 ? responseData['types'][1]['type']['name'] : null,
          weight: responseData['weight']
      );
      return details;
    } catch (e) {
      rethrow;
    }
  }
}