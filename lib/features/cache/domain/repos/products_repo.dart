import 'package:dartz/dartz.dart';
import 'package:test/core/errors/dio_errors.dart';
import 'package:test/features/cache/data/models/product_model.dart';

abstract class ProductRepo {
 Future<Either<Failure,List<ProductModel>>> getProducts({required int start , required int end});
}