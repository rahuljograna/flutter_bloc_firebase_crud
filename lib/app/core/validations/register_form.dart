import 'package:formz/formz.dart';

enum RegisterNameValidationError { empty }

enum RegisterEmailFieldValidationError { invalid }

enum RegisterPasswordFieldValidationError { empty }

enum RegisterConfirmPasswordFieldValidationError { empty, mismatch }

class RegisterNameField
    extends FormzInput<String, RegisterNameValidationError> {
  const RegisterNameField.pure([super.value = '']) : super.pure();
  const RegisterNameField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterNameValidationError? validator(String value) {
    if (value.isEmpty) return RegisterNameValidationError.empty;
    return null;
  }
}

class RegisterEmailField
    extends FormzInput<String, RegisterEmailFieldValidationError> {
  const RegisterEmailField.pure([super.value = '']) : super.pure();

  const RegisterEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  RegisterEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value)
        ? null
        : RegisterEmailFieldValidationError.invalid;
  }
}

class RegisterPasswordField
    extends FormzInput<String, RegisterPasswordFieldValidationError> {
  const RegisterPasswordField.pure([super.value = '']) : super.pure();
  const RegisterPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  RegisterPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return RegisterPasswordFieldValidationError.empty;
    return null;
  }
}

class RegisterConfirmedPasswordField
    extends FormzInput<String, RegisterConfirmPasswordFieldValidationError> {
  final String password;

  const RegisterConfirmedPasswordField.pure({this.password = ''})
      : super.pure('');

  const RegisterConfirmedPasswordField.dirty(
      {required this.password, String value = ''})
      : super.dirty(value);

  @override
  RegisterConfirmPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) {
      return RegisterConfirmPasswordFieldValidationError.empty;
    }
    return password == value
        ? null
        : RegisterConfirmPasswordFieldValidationError.mismatch;
  }
}
