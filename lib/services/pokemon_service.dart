import 'dart:collection';
import 'dart:convert';

import 'package:poke/models/gallery_name.dart';
import 'package:poke/repository/pokemon_api_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon.dart';

class PokemonService {

  final PokemonApiRepository _pokemonApiRepository;
  final SharedPreferences _sharedPreferences;

  PokemonService(this._pokemonApiRepository, this._sharedPreferences);

  Future<List<String>> getNames() async {
    var responseData = await _pokemonApiRepository.getNames();
    List<String> pokemonNames = [];
    for (var element in (responseData['results'] as List)) {
      element as Map<String, dynamic>;
      var name = element['name'] as String;
      pokemonNames.add(name);
    }
    return pokemonNames;
  }

  Future<Map<String, List<Pokemon>>> getSavedPokemons() async {
    Map<String, List<Pokemon>> pokemonByType = HashMap();
    var ids = _sharedPreferences.getKeys();
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
            _sharedPreferences.getString(p.id)!) as Map<String, dynamic>);

    p.galleryNameType = gallery.galleryName;
    p.galleryName = gallery.name;

    return p;
  }

  Future<Pokemon> getDetails(String name) async {
      var responseData = await _pokemonApiRepository.getDetails(name);
      var details = Pokemon.fromJson(responseData);

      if(_sharedPreferences.containsKey(details.id)){
        return _mergeGallery(details);
      }
      return details;
  }

  Future<void> saveToGallery(String id, String name, GalleryNameType galleryName) async {
    String json = jsonEncode(
        GalleryPokemon(name: name, id: id, galleryName: galleryName));

    await _sharedPreferences.setString(id, json);
  }

  Future<void> removeFromGallery(String id) async {
    await _sharedPreferences.remove(id);
  }
}