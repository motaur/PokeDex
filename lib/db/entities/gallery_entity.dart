import 'package:floor/floor.dart';

@entity
class GalleryEntity {
  @primaryKey
  final String id;
  final String name;
  final String nickName;

  GalleryEntity({required this.id, required this.name, required this.nickName});
}
