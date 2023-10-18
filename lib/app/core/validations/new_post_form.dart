import 'package:formz/formz.dart';

enum PostCoverValidationError { empty }

enum PostTitleValidationError { empty }

enum PostDescriptionValidationError { empty }

class PostCover extends FormzInput<String, PostCoverValidationError> {
  const PostCover.pure([super.value = '']) : super.pure();
  const PostCover.dirty([super.value = '']) : super.dirty();

  @override
  PostCoverValidationError? validator(String value) {
    if (value.isEmpty) return PostCoverValidationError.empty;
    return null;
  }
}

class PostTitleField extends FormzInput<String, PostTitleValidationError> {
  const PostTitleField.pure([super.value = '']) : super.pure();
  const PostTitleField.dirty([super.value = '']) : super.dirty();

  @override
  PostTitleValidationError? validator(String value) {
    if (value.isEmpty) return PostTitleValidationError.empty;
    return null;
  }
}

class PostDescriptionField
    extends FormzInput<String, PostDescriptionValidationError> {
  const PostDescriptionField.pure([super.value = '']) : super.pure();
  const PostDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  PostDescriptionValidationError? validator(String value) {
    if (value.isEmpty) return PostDescriptionValidationError.empty;
    return null;
  }
}
