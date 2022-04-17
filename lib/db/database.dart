import 'dart:async';
import 'package:floor/floor.dart';
import 'package:poke/db/entities/gallery_entity.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'daos/gallery_dao.dart';
part 'database.g.dart';

///Create database///
@Database(version: 1, entities: [GalleryEntity])
abstract class DataBase extends FloorDatabase {
  GalleryDao get galleryDao;
}
