part of 'new_post_bloc.dart';

enum AddPostStatus {
  initial,
  loading,
  success,
  failure,
  uploadingImage,
  submitting,
  uploadedImage
}

extension AddPostStatusX on AddPostStatus {
  bool get isInitial => this == AddPostStatus.initial;
  bool get isLoading => this == AddPostStatus.loading;
  bool get isSuccess => this == AddPostStatus.success;
  bool get isFailure => this == AddPostStatus.failure;
  bool get isUploadingImage => this == AddPostStatus.uploadingImage;
  bool get isSubmitting => this == AddPostStatus.submitting;
  bool get isUploadedImage => this == AddPostStatus.uploadedImage;
}

final class NewPostState {
  final AddPostStatus status;
  final PostCover cover;
  final PostTitleField title;
  final PostDescriptionField description;
  final bool isValid;
  final String toastMessage;

  const NewPostState({
    this.cover = const PostCover.pure(),
    this.title = const PostTitleField.pure(),
    this.description = const PostDescriptionField.pure(),
    this.status = AddPostStatus.initial,
    this.isValid = false,
    this.toastMessage = '',
  });

  NewPostState copyWith({
    AddPostStatus? status,
    PostCover? cover,
    PostTitleField? title,
    PostDescriptionField? description,
    bool? isValid,
    String? toastMessage,
  }) {
    return NewPostState(
      cover: cover ?? this.cover,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }
}
