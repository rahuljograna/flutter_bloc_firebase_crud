import 'package:formz/formz.dart';

enum LoginEmailFieldValidationError { invalid }

enum LoginPasswordFieldValidationError { empty }

class LoginEmailField
    extends FormzInput<String, LoginEmailFieldValidationError> {
  const LoginEmailField.pure([super.value = '']) : super.pure();

  const LoginEmailField.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  @override
  LoginEmailFieldValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value)
        ? null
        : LoginEmailFieldValidationError.invalid;
  }
}

class LoginPasswordField
    extends FormzInput<String, LoginPasswordFieldValidationError> {
  const LoginPasswordField.pure([super.value = '']) : super.pure();
  const LoginPasswordField.dirty([super.value = '']) : super.dirty();

  @override
  LoginPasswordFieldValidationError? validator(String value) {
    if (value.isEmpty) return LoginPasswordFieldValidationError.empty;
    return null;
  }
}
