import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 1)
class Favorite {
  @HiveField(0)
  String imgUrl;

  @HiveField(1)
  String name;

  @HiveField(2)
  String id;
  Favorite({required this.imgUrl, required this.name, required this.id});
}
