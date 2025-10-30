import 'package:dio/dio.dart';
import 'package:elyx_task/core/constants/api_string.dart';
import 'package:elyx_task/features/home/data/models/user_data_model.dart';
import 'package:retrofit/retrofit.dart';

part 'home_datasource.g.dart';

@RestApi(baseUrl: ApiString.baseUrl)
abstract class HomeDatasource {
  factory HomeDatasource(Dio dio, {String baseUrl}) = _HomeDatasource;

  @GET('/users')
  Future<UserDataModel> getUserData(
    @Query("page") String page,
    @Query("per_page") String count,
  );
}
