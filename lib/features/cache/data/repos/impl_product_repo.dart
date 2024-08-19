// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:test/core/errors/dio_errors.dart';
import 'package:test/features/cache/data/data_sources/remote_data_source.dart';
import 'package:test/features/cache/data/models/product_model.dart';
import 'package:test/features/cache/domain/repos/products_repo.dart';

class ImplProductRepo implements ProductRepo {
  RemoteDataSource remoteDataSource;
  ImplProductRepo({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, List<ProductModel>>> getProducts(
      {required int start, required int end}) async {
    try {
      List<ProductModel> products =
          await remoteDataSource.getProducts(start: start, end: end);
          return right(products);
    } catch (e) {
      if (e is DioException) {
        return left(ServerError.fromDioError(e));
      }
      return left(ServerError(e.toString()));
    }
  }
}
