import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/core/utils/api_services.dart';
import 'package:test/features/cache/data/models/product_model.dart';
import 'package:test/features/cache/domain/entities/product_entity.dart';

abstract class RemoteDataSource {
  Future<List<ProductEntity>> getProducts({int? start, int? end});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  ApiServices apiServices;
  RemoteDataSourceImpl({required this.apiServices});
  @override
  Future<List<ProductEntity>> getProducts({int? start, int? end}) async {
    List<ProductEntity> products = [];
    var response = await apiServices.getData('products', "?order=id.desc");
    for (var product in response.data) {
      products.add(ProductModel.fromJson(product));
    }

    var box = Hive.box<ProductEntity>('products');
    box.putAll({for (var product in products) product.id: product});

    return products;
  }
}
