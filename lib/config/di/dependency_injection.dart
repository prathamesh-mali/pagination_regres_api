import 'package:dio/dio.dart';
import 'package:elyx_task/core/constants/api_string.dart';
import 'package:elyx_task/features/home/data/datasources/home_datasource.dart';
import 'package:elyx_task/features/home/data/repository/home_repository.dart';
import 'package:elyx_task/features/home/domain/repository/home_repository_impl.dart';
import 'package:elyx_task/features/home/domain/usecases/home_usecase.dart';
import 'package:elyx_task/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final sl = GetIt.instance;
Future<void> setupLocator() async {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiString.baseUrl,
      contentType: Headers.jsonContentType,
      headers: {'x-api-key': dotenv.env['X_API_KEY'] ?? ''},
    ),
  );
  dio.options.contentType = "application/json";

  if (kDebugMode) {
    dio.interceptors.addAll([
      PrettyDioLogger(requestHeader: true, requestBody: true, error: true),
    ]);
  }
  sl.registerLazySingleton<Dio>(() => dio);
  sl.registerFactory(() => HomeDatasource(dio));
  sl.registerFactory<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerFactory(() => HomeUsecase(repository: sl()));
  sl.registerFactory(() => HomeCubit(sl()));
}
