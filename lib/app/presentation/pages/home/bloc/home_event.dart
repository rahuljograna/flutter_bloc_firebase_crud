part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeLogoutEvent extends HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

final class HomeUpdateStatusPostEvent extends HomeEvent {
  final int index;
  final PostModel postModel;

  HomeUpdateStatusPostEvent({required this.index, required this.postModel});
}

final class HomeDeletePostEvent extends HomeEvent {
  final PostModel postModel;

  HomeDeletePostEvent({required this.postModel});
}
