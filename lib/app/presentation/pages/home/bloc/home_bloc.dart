import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/post_model.dart';
import 'package:flutter_bloc_firebase_crud/app/core/repositories/auth_repository.dart';
import 'package:flutter_bloc_firebase_crud/app/core/repositories/post_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository _authRepository = AuthRepository();
  final PostRepository _postRepository = PostRepository();
  List<PostModel> list = <PostModel>[];
  HomeBloc() : super(const HomeState()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);
    on<HomeLogoutEvent>(_onHomeLogoutEvent);
    on<HomeUpdateStatusPostEvent>(_onHomeUpdateStatusPostEvent);
    on<HomeDeletePostEvent>(_onHomeDeletePostEvent);
  }

  Future<void> _onHomeLogoutEvent(
      HomeLogoutEvent event, Emitter<HomeState> emit) async {
    await _authRepository.signOut();
    emit(
      state.copyWith(
        status: HomeStatus.logout,
        toastMesssage: 'Logged Out',
      ),
    );
  }

  Future<void> _onHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      await _postRepository.getUserId().then((userId) async {
        debugPrint(userId);
        if (userId != null) {
          list = await _postRepository.retrieveMyPost(userId);
          list.sort((a, b) {
            return b.timestamp!.compareTo(a.timestamp!);
          });
          emit(
            state.copyWith(
              status: HomeStatus.success,
              list: [...list],
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: HomeStatus.unAuthorized,
              toastMesssage: 'Unauthorized',
            ),
          );
        }
      }).catchError((onError) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            toastMesssage: onError.toString(),
          ),
        );
      });
    } catch (e) {
      debugPrint('catch ${e.toString()}');
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMesssage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onHomeUpdateStatusPostEvent(
      HomeUpdateStatusPostEvent event, Emitter<HomeState> emit) async {
    debugPrint('update status');
    try {
      debugPrint('before ${event.postModel.status.toString()}');
      event.postModel.status = event.postModel.status == 1 ? 0 : 1;
      debugPrint('after ${event.postModel.status.toString()}');
      await _postRepository
          .updatePost(event.postModel.id!, {"status": event.postModel.status});

      emit(
        state.copyWith(
          status: HomeStatus.success,
          list: [...list],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMesssage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onHomeDeletePostEvent(
      HomeDeletePostEvent event, Emitter<HomeState> emit) async {
    debugPrint('call delete api with this id ${event.postModel.id}');
    try {
      debugPrint(event.postModel.title.toString());
      debugPrint(event.postModel.id.toString());
      await _postRepository.deletePost(event.postModel.id!);
      list.removeWhere((element) => element.id == event.postModel.id);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          list: [...list],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMesssage: e.toString(),
        ),
      );
    }
  }
}
