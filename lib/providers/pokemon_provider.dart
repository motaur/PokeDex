import 'package:flutter/cupertino.dart';

import 'package:poke/models/gallery_name.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider with ChangeNotifier {

  final PokemonService _pokemonService;

  PokemonProvider(this._pokemonService);

  Future<List<String>> getNames() async {
    var names = _pokemonService.getNames();
    return names;
  }

  Future<Map<String, List<Pokemon>>> getSavedPokemons() async {
    return _pokemonService.getSavedPokemons();
  }

  Future<Pokemon> getDetails(String name) async {
    return _pokemonService.getDetails(name);
  }

  Future<void> saveToGallery(String id, String name, GalleryNameType galleryName) async {
    await _pokemonService.saveToGallery(id, name, galleryName);
    notifyListeners();
  }

  Future<void> deleteFromGallery(String id) async {
    await _pokemonService.removeFromGallery(id);
    notifyListeners();
  }
}