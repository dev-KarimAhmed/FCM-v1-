import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test/features/cache/data/models/product_model.dart';
import 'package:test/features/cache/domain/entities/product_entity.dart';
import 'package:test/features/cache/domain/repos/products_repo.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this.repo) : super(ProductInitial());

  ProductRepo repo;

  List<ProductEntity> products = [];
  Future<void> getProducts() async {
      emit(GetProductLoading());
    // if (start == 0) {
    //   emit(GetProductLoading());
    // } else {
    //   emit(GetDataPaginationLoading());
    // }
    var result = await repo.getProducts();
    result.fold((failure) {
        log("GetProductError: ${failure.errMessage}");
        emit(GetProductError(failure.errMessage));
      // if (start == 0) {
      //   log("GetProductError: ${failure.errMessage}");
      //   emit(GetProductError(failure.errMessage));
      // } else {
      //   emit(GetDataPaginationError());
      // }
    }, (products) {
        this.products = products;
      // if (start == 0) {
      //   this.products = products;
      // } else {
      //   this.products.addAll(products);
      // }
      emit(GetProductSuccess());
    });
  }
}
