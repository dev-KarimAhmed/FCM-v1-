import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:test/core/utils/api_services.dart';
import 'package:test/features/cache/data/data_sources/remote_data_source.dart';
import 'package:test/features/cache/data/repos/impl_product_repo.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ApiServices>(ApiServices(Dio()));
  getIt.registerSingleton<ImplProductRepo>(ImplProductRepo(
      remoteDataSource:
          RemoteDataSourceImpl(apiServices: getIt<ApiServices>())));
}
