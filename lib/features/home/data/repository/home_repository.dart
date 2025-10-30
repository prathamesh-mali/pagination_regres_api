import 'package:dartz/dartz.dart';
import 'package:elyx_task/config/failures/failures.dart';
import 'package:elyx_task/features/home/data/models/user_data_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserDataModel>> getUserData(String page, String count);
}
