part of 'home_bloc.dart';

enum HomeStatus { loading, unAuthorized, failure, logout, success }

extension HomeStatusX on HomeStatus {
  bool get isLoading => this == HomeStatus.loading;
  bool get isUnAuthorized => this == HomeStatus.unAuthorized;
  bool get isFailure => this == HomeStatus.failure;
  bool get isLogout => this == HomeStatus.logout;
  bool get isSuccess => this == HomeStatus.success;
}

final class HomeState {
  final HomeStatus status;
  final String toastMesssage;
  final List<PostModel> list;
  const HomeState({
    this.status = HomeStatus.loading,
    this.toastMesssage = '',
    this.list = const [],
  });

  HomeState copyWith({
    HomeStatus? status,
    String? toastMesssage,
    List<PostModel>? list,
  }) {
    return HomeState(
      status: status ?? this.status,
      toastMesssage: toastMesssage ?? this.toastMesssage,
      list: list ?? this.list,
    );
  }
}
