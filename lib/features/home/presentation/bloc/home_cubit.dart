import 'package:elyx_task/features/home/data/models/user_data_model.dart';
import 'package:elyx_task/features/home/domain/usecases/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUsecase _homeUsecase;

  HomeCubit(this._homeUsecase) : super(const HomeState.initial());

  int _page = 1;
  final int _count = 8;
  bool _hasReachedEnd = false;
  bool _isFetching = false;

  List<UserData> get users {
    return state.maybeWhen(
      loaded: (response) => response.data ?? [],
      orElse: () => <UserData>[],
    );
  }

  bool get hasReachedEnd => _hasReachedEnd;

  Future<void> fetchHomeData({bool isRefresh = false}) async {
    if (_isFetching) return;

    if (_hasReachedEnd && !isRefresh) return;

    _isFetching = true;

    if (state is _Initial) emit(const HomeState.loading());

    if (isRefresh) {
      _page = 1;
      _hasReachedEnd = false;
    }

    final result = await _homeUsecase.call(_page.toString(), _count.toString());

    result.fold(
      (failure) {
        _isFetching = false;
        emit(HomeState.error(failure.runtimeType.toString()));
      },
      (data) {
        _isFetching = false;

        final currentData = state.maybeWhen(
          loaded: (response) => response,
          orElse: () => null,
        );

        if (data.totalPages != null && _page >= data.totalPages!) {
          _hasReachedEnd = true;
        }

        if (data.data == null || data.data!.isEmpty) {
          _hasReachedEnd = true;
          if (currentData != null) emit(HomeState.loaded(currentData));
          return;
        }

        if (currentData != null && !isRefresh) {
          final existingIds = currentData.data?.map((u) => u.id).toSet() ?? {};
          final newUsers = data.data!
              .where((u) => !existingIds.contains(u.id))
              .toList();

          final mergedData = UserDataModel(
            page: data.page,
            perPage: data.perPage,
            total: data.total,
            totalPages: data.totalPages,
            data: [...currentData.data ?? [], ...newUsers],
            support: data.support,
            meta: data.meta,
          );

          emit(HomeState.loaded(mergedData));
        } else {
          emit(HomeState.loaded(data));
        }

        _page++;
      },
    );
  }

  void reset() {
    _page = 1;
    _hasReachedEnd = false;
    _isFetching = false;
    emit(const HomeState.initial());
  }
}
