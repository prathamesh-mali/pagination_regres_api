import 'package:elyx_task/features/home/data/repository/home_repository.dart';

class HomeUsecase {
  final HomeRepository repository;
  HomeUsecase({required this.repository});

  Future<dynamic> call(String page, String count) async {
    return await repository.getUserData(page, count);
  }
}
