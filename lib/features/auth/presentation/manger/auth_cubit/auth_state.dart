part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final class AuthSuccess extends AuthState {}

final class GetDataSuccess extends AuthState {}
final class GetDataError extends AuthState {}
final class GetDataLoading extends AuthState {}
final class GetDataPaginationLoading extends AuthState {}
final class GetDataPaginationSuccess extends AuthState {}
final class GetDataPaginationError extends AuthState {}
