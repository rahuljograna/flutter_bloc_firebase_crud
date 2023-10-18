import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/post_model.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/user_model.dart';
import 'package:flutter_bloc_firebase_crud/app/core/repositories/auth_repository.dart';
import 'package:flutter_bloc_firebase_crud/app/core/repositories/post_repository.dart';
import 'package:flutter_bloc_firebase_crud/app/core/validations/new_post_form.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
part 'new_post_event.dart';
part 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthRepository _authRepository = AuthRepository();
  final PostRepository _postRepository = PostRepository();
  NewPostBloc() : super(const NewPostState()) {
    on<NewPostInitialEvent>(_onNewPostInitialEvent);

    on<OnPostImagePickerEvent>(_onPostImagePickerEvent);

    on<PostTitleChanged>(_onTitleChanged);

    on<PostTitleUnfocused>(_onTitleUnfocused);

    on<PostDescriptionChanged>(_onDescriptionChanged);

    on<PostDescriptionUnfocused>(_onDescriptionUnfocused);

    on<PostFormSubmitted>(_onPostFormSubmitted);
  }

  Future<void> _onNewPostInitialEvent(
      NewPostInitialEvent event, Emitter<NewPostState> emit) async {
    debugPrint('is New? ${event.action}, and the id ${event.postModel.id}');
    if (event.action == 'update') {
      debugPrint('update');
      emit(
        state.copyWith(
          title: PostTitleField.pure(event.postModel.title!),
          description: PostDescriptionField.pure(event.postModel.description!),
          cover: PostCover.pure(event.postModel.cover!),
          isValid: Formz.validate([
            state.title,
            state.description,
            state.cover,
          ]),
        ),
      );
    }
  }

  Future<void> _onPostImagePickerEvent(
      OnPostImagePickerEvent event, Emitter<NewPostState> emit) async {
    debugPrint(event.kind.toString());
    try {
      final pickedFile = await ImagePicker().pickImage(
          source: event.kind == 'gallery'
              ? ImageSource.gallery
              : ImageSource.camera,
          imageQuality: 25);
      debugPrint(pickedFile.toString());

      /// TEST

      // const cover = PostCover.dirty(
      //     'https://firebasestorage.googleapis.com/v0/b/flutter-bloc-firebase-cr-34925.appspot.com/o/images%2Fscaled_IMG_20231013_113921071.jpg?alt=media&token=d3484d26-88ec-49d9-8f32-f156cfe1d524');
      // emit(
      //   state.copyWith(
      //     cover: cover.isValid
      //         ? cover
      //         : const PostCover.pure(
      //             'https://firebasestorage.googleapis.com/v0/b/flutter-bloc-firebase-cr-34925.appspot.com/o/images%2Fscaled_IMG_20231013_113921071.jpg?alt=media&token=d3484d26-88ec-49d9-8f32-f156cfe1d524'),
      //     isValid: Formz.validate([cover, state.title, state.description]),
      //   ),
      // );

      /// TEST

      if (pickedFile != null) {
        UploadTask uploadTask;
        Reference ref = _storage.ref().child('images/').child(pickedFile.name);

        uploadTask = ref.putFile(io.File(pickedFile.path));
        await uploadTask.whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            debugPrint(value);
            final cover = PostCover.dirty(value);
            emit(
              state.copyWith(
                cover: cover.isValid ? cover : PostCover.pure(value),
                isValid:
                    Formz.validate([cover, state.title, state.description]),
              ),
            );
          });
        });
      }
    } catch (e) {
      debugPrint('catch the error ${e.toString()}');
      emit(state.copyWith(
          status: AddPostStatus.failure, toastMessage: e.toString()));
    }
  }

  Future<void> _onTitleChanged(
      PostTitleChanged event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(event.title);
    emit(
      state.copyWith(
        title: title.isValid ? title : PostTitleField.pure(event.title),
        status: AddPostStatus.initial,
        isValid: Formz.validate([title, state.cover, state.description]),
      ),
    );
  }

  Future<void> _onTitleUnfocused(
      PostTitleUnfocused event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(state.title.value);
    emit(
      state.copyWith(
        title: title,
        status: AddPostStatus.initial,
        isValid: Formz.validate([title, state.cover, state.description]),
      ),
    );
  }

  Future<void> _onDescriptionChanged(
      PostDescriptionChanged event, Emitter<NewPostState> emit) async {
    final description = PostDescriptionField.dirty(event.description);
    emit(
      state.copyWith(
        description: description.isValid
            ? description
            : PostDescriptionField.pure(event.description),
        status: AddPostStatus.initial,
        isValid: Formz.validate([description, state.cover, state.title]),
      ),
    );
  }

  Future<void> _onDescriptionUnfocused(
      PostDescriptionUnfocused event, Emitter<NewPostState> emit) async {
    final description = PostDescriptionField.dirty(state.description.value);
    emit(
      state.copyWith(
        description: description,
        status: AddPostStatus.initial,
        isValid: Formz.validate([description, state.cover, state.title]),
      ),
    );
  }

  Future<void> _onPostFormSubmitted(
      PostFormSubmitted event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(state.title.value);
    final description = PostDescriptionField.dirty(state.description.value);
    final cover = PostCover.dirty(state.cover.value);
    emit(
      state.copyWith(
        title: title,
        description: description,
        cover: cover,
        status: AddPostStatus.initial,
        isValid: Formz.validate([
          title,
          description,
          cover,
        ]),
      ),
    );
    if (state.isValid) {
      UserModel user = await _authRepository.retrieveCurrentUser().first;
      if (user.uid != "uid") {
        debugPrint('ok Submit');
        if (event.action == 'create') {
          debugPrint('create');
          var param = {
            "cover": state.cover.value.toString(),
            "title": state.title.value.toString(),
            "description": state.description.value.toString(),
            "userId": user.uid,
            "timestamp": DateTime.timestamp(),
            "status": 1
          };
          await _postRepository.addPost(param);
          emit(state.copyWith(
            status: AddPostStatus.success,
            toastMessage: 'Post Saved',
          ));
        } else {
          debugPrint('update');
          emit(state.copyWith(status: AddPostStatus.submitting));
          var param = {
            "cover": state.cover.value.toString(),
            "title": state.title.value.toString(),
            "description": state.description.value.toString(),
            "userId": user.uid,
          };
          await _postRepository.updatePost(event.postModel.id!, param);
          emit(state.copyWith(
            status: AddPostStatus.success,
            toastMessage: 'Post Updated',
          ));
        }
      } else {
        debugPrint('unauthorized');
        emit(state.copyWith(status: AddPostStatus.failure));
      }
    }
  }
}
