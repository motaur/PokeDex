import 'package:flutter/cupertino.dart';
import 'package:poke/models/gallery_name.dart';

class Pokemon extends ChangeNotifier {

  GalleryName? galleryName;
  String? givenName;

  final String id;
  final String name;
  final sprite;
  final type1;
  final type2;
  final weight;

  Pokemon({
    required this.id,
    required this.name,
    this.sprite,
    this.type1,
    this.type2,
    this.weight
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
        galleryName = json['nickName'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'nickName': galleryName,
  };
}