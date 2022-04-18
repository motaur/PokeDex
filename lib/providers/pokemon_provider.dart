import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:poke/models/gallery_name.dart';

import '../main.dart';
import '../models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonProvider with ChangeNotifier {

  final _baseUrl = "https://pokeapi.co/api/v2/pokemon";

  Future<List<String>> getNames() async {
    try {
      Uri url = Uri.parse("$_baseUrl/?offset=0&limit=999999");
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      List<String> pokemonNames = [];
      for (var element in (responseData['results'] as List)) {
        element as Map<String, dynamic>;
        var name = element['name'] as String;
        pokemonNames.add(name);
      }
      notifyListeners();
      return pokemonNames;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<Map<String, List<Pokemon>>> getSavedPokemons() async {
    Map<String, List<Pokemon>> pokemonByType = HashMap();

    var ids = prefs.getKeys();
    List<Future<Pokemon>> requests = [];

    for (var id in ids) {
      requests.add(getDetails(id));
    }
    final results = await Future.wait(requests).catchError((onError) => throw(onError));

    List<Pokemon> merged = [];

    for (var element in results) {
      merged.add(
          _mergeGallery(element));
    }

    for (var pokemon in merged) {
      List<Pokemon> list = [];
      pokemonByType.addEntries({ pokemon.type : list }.entries);
    }

    for (var pokemon in merged) {
      pokemonByType.update(pokemon.type, (List<Pokemon> value) {
        value.add(pokemon);
        return value;
      });
    }
    return pokemonByType;
  }

  Pokemon _mergeGallery(Pokemon p){
    var gallery = GalleryPokemon.fromJson(
        json.decode(
            prefs.getString(p.id)!) as Map<String, dynamic>);

    p.galleryNameType = gallery.galleryName;
    p.galleryName = gallery.name;

    return p;
  }

  Future<Pokemon> getDetails(String name) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/$name"));
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      var details = Pokemon(
          id: responseData['id'].toString(),
          name: responseData['name'],
          sprite: responseData['sprites']['front_default'],
          type: responseData['types'][0]['type']['name'],
          weight: responseData['weight']
      );

      if(prefs.containsKey(details.id)){
        return _mergeGallery(details);
      }
      return details;

    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<void> saveToGallery(String id, String name, GalleryNameType galleryName) async {
    String json = jsonEncode(
        GalleryPokemon(name: name, id: id, galleryName: galleryName));
    await prefs.setString(id, json);
  }

  Future<void> deleteFromGallery(String id) async {
    await prefs.remove(id);
  }
}