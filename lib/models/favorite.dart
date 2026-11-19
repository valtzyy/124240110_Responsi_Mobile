import 'package:hive/hive.dart';
part 'favorite.g.dart';

@HiveType(typeId: 0)
class Favorite extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? image;
  @HiveField(3)
  final double? rating;

  Favorite({required this.id, required this.title, this.image, this.rating});
}