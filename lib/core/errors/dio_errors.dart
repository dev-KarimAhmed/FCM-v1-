import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerError extends Failure {
  ServerError(super.errMessage);

  factory ServerError.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ServerError('Request to API server was cancelled');
      case DioExceptionType.connectionTimeout:
        return ServerError('Connection timeout with API server');
      case DioExceptionType.connectionError:
        return ServerError(
            'Connection to API server failed due to internet connection');
      case DioExceptionType.receiveTimeout:
        return ServerError('Receive timeout in connection with API server');
      case DioExceptionType.badResponse:
        if (dioError.response!.statusCode == 400 ||
            dioError.response!.statusCode == 401 ||
            dioError.response!.statusCode == 403) {
          return ServerError(dioError.response!.data['error']['message']);
        }
        if (dioError.response!.statusCode == 404) {
          return ServerError('Not found');
        }
        if (dioError.response!.statusCode == 409) {
          return ServerError('Conflict');
        }
        if (dioError.response!.statusCode == 500) {
          return ServerError('Internal server error');
        } else {
          return ServerError('Something went wrong , please try again later');
        }
      case DioExceptionType.sendTimeout:
        return ServerError('Send timeout in connection with API server');
      default:
        if (dioError.message!.contains('SocketException')) {
          return ServerError('No internet connection');
        }
        return ServerError('Something went wrong , please try again later');
    }
  }
}