import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/features/cache/domain/entities/product_entity.dart';

abstract class LocalDataSource {
  List<ProductEntity> getProducts({int? start, int? end});
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  List<ProductEntity> getProducts({int? start, int? end}) {
    return getProductsFromDB(start: start, end: end);
  }

  List<ProductEntity> getProductsFromDB({int? start, int? end}) {
    var box = Hive.box<ProductEntity>('products');
    return box.values.toList();
  }
}
