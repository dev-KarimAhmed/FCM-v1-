import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'product_entity.g.dart';

 @HiveType(typeId: 0)
class ProductEntity extends Equatable {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final double? price;
  @HiveField(4)
  final String? imageUrl;

  const ProductEntity({required this.id, required this.name, required this.description, required this.price, required this.imageUrl});
  
  @override
  // TODO: implement props
  List<Object?> get props => [id, name, description, price, imageUrl];
}
