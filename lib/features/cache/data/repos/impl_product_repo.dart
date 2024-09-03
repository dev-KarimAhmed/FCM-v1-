// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:test/core/errors/dio_errors.dart';
import 'package:test/features/cache/data/data_sources/local_data_source.dart';
import 'package:test/features/cache/data/data_sources/remote_data_source.dart';
import 'package:test/features/cache/data/models/product_model.dart';
import 'package:test/features/cache/domain/entities/product_entity.dart';
import 'package:test/features/cache/domain/repos/products_repo.dart';

class ImplProductRepo implements ProductRepo {
  RemoteDataSource remoteDataSource;
  LocalDataSource localDataSource;
  ImplProductRepo({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      List<ProductEntity> products = [];

      products = localDataSource.getProducts();

      if (products.isNotEmpty) {
        log("products:Local");
        return Right(products);
      }
      products = await remoteDataSource.getProducts();
      log("products:Remote");

      return Right(products);
    } catch (e) {
      if (e is DioException) {
        return left(ServerError.fromDioError(e));
      }
      return left(ServerError(e.toString()));
    }
  }
}
