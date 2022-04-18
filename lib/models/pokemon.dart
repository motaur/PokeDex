import 'package:flutter/cupertino.dart';
import 'package:poke/models/gallery_name.dart';

class Pokemon extends ChangeNotifier {

  GalleryNameType? galleryNameType;
  String? galleryName;

  final String id;
  final String name;
  final String sprite;
  final String type;
  final num weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.sprite,
    required this.type,
    required this.weight
  });

  Pokemon.fromJson(Map<String, dynamic> json):
        id = json['id'].toString(),
        name = json['name'],
        sprite = json['sprites']['front_default'],
        type = json['types'][0]['type']['name'],
        weight = json['weight'];
}

class GalleryPokemon {
  final String id;
  final String name;
  final GalleryNameType galleryName;

  GalleryPokemon({
    required this.id,
    required this.name,
    required this.galleryName
  });

  GalleryPokemon.fromJson(Map<String, dynamic> json) :
        name = json['name'],
        galleryName = GalleryNameType.values[json['galleryName']],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'galleryName': galleryName.index,
  };
}