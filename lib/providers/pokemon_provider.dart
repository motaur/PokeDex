import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:poke/db/entities/gallery_entity.dart';
import 'package:poke/models/gallery_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/database.dart';
import '../main.dart';
import '../models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonProvider with ChangeNotifier {

  final _baseUrl = "https://pokeapi.co/api/v2/pokemon";

  List<String> pokemonNames = [];
  List<Pokemon> gallery = [];
  late Pokemon details;

  Future<List<String>> getNames() async {
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
      return pokemonNames;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Pokemon>> getSavedPokemons() async {
    var ids = prefs.getKeys();

    List<Future<Pokemon>> requests = [];

    for (var id in ids) {
      requests.add(getDetails(id));
    }
    final results = await Future.wait(requests);

    results.map((Pokemon p) => _mergeGallery(p));

    gallery = results;

    return results;
  }

  Pokemon _mergeGallery(Pokemon p){
    var gallery = GalleryPokemon.fromJson(
        json.decode(
            prefs.getString(p.id)!) as Map<String, dynamic>);

    p.galleryName = gallery.galleryName;
    p.givenName = gallery.name;

    return p;
  }

  Future<Pokemon> getDetails(String name) async {

    try {
      final response = await http.get(Uri.parse("$_baseUrl/$name"));
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      details = Pokemon(
          id: responseData['id'].toString(),
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

  Future<void> saveToGallery(String id, String name, GalleryName galleryName) async {

    String json = jsonEncode(GalleryPokemon(name: name, id: id, galleryName: galleryName));
    prefs.setString(id, json);
  }
}