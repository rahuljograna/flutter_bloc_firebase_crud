part of 'new_post_bloc.dart';

sealed class NewPostEvent {}

final class NewPostInitialEvent extends NewPostEvent {
  final String action;
  final PostModel postModel;
  NewPostInitialEvent({required this.action, required this.postModel});
}

final class OnPostImagePickerEvent extends NewPostEvent {
  final String kind;
  OnPostImagePickerEvent({required this.kind});
}

final class PostTitleChanged extends NewPostEvent {
  final String title;

  PostTitleChanged({required this.title});
}

final class PostTitleUnfocused extends NewPostEvent {}

final class PostDescriptionChanged extends NewPostEvent {
  final String description;

  PostDescriptionChanged({required this.description});
}

final class PostDescriptionUnfocused extends NewPostEvent {}

final class PostFormSubmitted extends NewPostEvent {
  final String action;
  final PostModel postModel;
  PostFormSubmitted({required this.action, required this.postModel});
}
