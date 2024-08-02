import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/core/utils/api_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.apiServices) : super(AuthInitial());
  ApiServices apiServices;
  final SupabaseClient client = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await client.auth.signInWithPassword(email: email, password: password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    log(password);
    try {
      await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'email': email,
        },
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  List<Order> orders = [];
  Future<void> getData({int start = 0, int end = 29}) async {
    if (start == 0) {
      emit(GetDataLoading());
    } else {
      emit(GetDataPaginationLoading());
    }
    try {
      var data = await apiServices.getData('orders', '', start, end);
      for (var order in data.data) {
        orders.add(Order.fromJson(order));
        orders = orders.toSet().toList();
      }
      emit(GetDataSuccess());
    } catch (e) {
      log(e.toString());
      if (start == 0) {
        emit(GetDataError());
      } else {
        emit(GetDataPaginationError());
      }
    }
  }
}

class Order extends Equatable {
  final String id;
  final String createdAt;
  final String name;
  final String price;

  Order({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.price,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      createdAt: json['created_at'],
      name: json['name'],
      price: json['price'],
    );
  }

  @override
  List<Object> get props => [id, createdAt, name, price];

  @override
  bool get stringify =>
      true; // Optional: Include toString in equality comparison
}
