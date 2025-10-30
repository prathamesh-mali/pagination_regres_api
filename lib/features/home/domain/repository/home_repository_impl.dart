import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:elyx_task/config/exceptions/exceptions.dart';
import 'package:elyx_task/config/failures/failures.dart';
import 'package:elyx_task/features/home/data/datasources/home_datasource.dart';
import 'package:elyx_task/features/home/data/models/user_data_model.dart';
import 'package:elyx_task/features/home/data/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource _client;
  HomeRepositoryImpl(this._client);
  @override
  Future<Either<Failure, UserDataModel>> getUserData(
    String page,
    String count,
  ) async {
    try {
      final userDataModel = await _client.getUserData(page, count);
      return right(userDataModel);
    } on SocketException catch (_) {
      return left(ConnectionFailure());
    } on TimeoutException catch (_) {
      return left(TimeoutFailure());
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      return left(GeneralFailure());
    }
  }
}
