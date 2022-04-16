import 'package:flutter/cupertino.dart';

class Pokemon extends ChangeNotifier {
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