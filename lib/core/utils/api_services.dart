
import 'package:dio/dio.dart';

class ApiServices {
  final String _baseUrl = 'https://chmbtstlcowseaunxdcd.supabase.co/rest/v1/';
  final Dio dio;
  final apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNobWJ0c3RsY293c2VhdW54ZGNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjIwNzM4NDMsImV4cCI6MjAzNzY0OTg0M30.rTO1Hw3zmrSYxBbgM1up_yms08PmibF_rTMCC02TNfE';
  ApiServices(this.dio);

  Future<Response> getData(String endpoint, String filter ,int start,  int end) async {
    return await dio.get(_baseUrl + endpoint + filter,
        options: Options(headers: {
          'apikey': apiKey,
          'Range' : "$start-$end"
        }));
  }

  Future<Response> postData(
      {required String endpoint, Map<String, dynamic>? data}) async {
    return await dio.post(_baseUrl + endpoint,
        data: data,
        options: Options(headers: {
          'apikey': apiKey,
        }));
  }

  Future<Response> patchData(
      {required String endpoint,
      required String filter,
      Map<String, dynamic>? data}) async {
    return await dio.patch(
      _baseUrl + endpoint + filter,
      data: data,
      options: Options(headers: {
        'apikey': apiKey,
      }),
    );
  }


}