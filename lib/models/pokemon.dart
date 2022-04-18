import 'package:flutter/cupertino.dart';
import 'package:poke/models/gallery_name.dart';

class Pokemon extends ChangeNotifier {

  GalleryName? galleryName;
  String? givenName;

  final String id;
  final String name;
  final String sprite;
  final String type1;
  final num weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.sprite,
    required this.type1,
    required this.weight
  });
}

class GalleryPokemon {
  final String id;
  final String name;
  final GalleryName galleryName;

  GalleryPokemon({
    required this.id,
    required this.name,
    required this.galleryName});

  GalleryPokemon.fromJson(Map<String, dynamic> json) :
        name = json['name'],
        galleryName = GalleryName.values[json['galleryName']],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'galleryName': galleryName.index,
  };
}