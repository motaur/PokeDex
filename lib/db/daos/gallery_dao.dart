import 'dart:async';

import 'package:floor/floor.dart';
import 'package:poke/db/entities/gallery_entity.dart';

@dao
abstract class GalleryDao {

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertData(GalleryEntity galleryEntity);

  @Query('SELECT * FROM GalleryEntity')
  Future<List<GalleryEntity>?> getAllData();

  @Query('DELETE FROM GalleryEntity WHERE id = :id')
  Future<GalleryEntity?> deleteData(String id);
}