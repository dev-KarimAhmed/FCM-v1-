import 'package:dartz/dartz.dart';
import 'package:test/core/errors/dio_errors.dart';
import 'package:test/features/cache/data/models/product_model.dart';
import 'package:test/features/cache/domain/entities/product_entity.dart';

abstract class ProductRepo {
 Future<Either<Failure,List<ProductEntity>>> getProducts();
}