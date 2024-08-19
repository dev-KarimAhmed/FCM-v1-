import 'package:test/core/utils/api_services.dart';
import 'package:test/features/cache/data/models/product_model.dart';

abstract class RemoteDataSource {
  Future<List<ProductModel>> getProducts(
      {required int start, required int end});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  ApiServices apiServices;
  RemoteDataSourceImpl({required this.apiServices});
  @override
  Future<List<ProductModel>> getProducts(
      {required int start, required int end}) async {
        List<ProductModel> products = [];
    var response = await apiServices.getData('products', "", start, end);
    for (var product in response.data) {
      products.add(ProductModel.fromJson(product));
    }

    return products;
    
  }
}
