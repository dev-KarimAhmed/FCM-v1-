import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

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
}
