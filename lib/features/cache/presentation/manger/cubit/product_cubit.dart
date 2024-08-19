import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test/features/cache/data/models/product_model.dart';
import 'package:test/features/cache/domain/repos/products_repo.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this.repo) : super(ProductInitial());

  ProductRepo repo;

 List<ProductModel> products = [];
  Future<void> getProducts({int start = 0, int end = 19}) async {
     if (start == 0) {
      emit(GetProductLoading());
    } else {
      emit(GetDataPaginationLoading());
    }
    var result = await repo.getProducts(start: start, end: end);
    result.fold((failure) {
       if (start == 0) {
        emit(GetProductError(failure.errMessage));
      } else {
        emit(GetDataPaginationError());
      }
    }, (products) {
      if (start == 0) {
        this.products = products;
      } else {
        this.products.addAll(products);
      }
      emit(GetProductSuccess());
    });
  }
}
