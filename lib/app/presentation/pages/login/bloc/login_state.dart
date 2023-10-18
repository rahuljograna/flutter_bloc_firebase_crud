part of 'login_bloc.dart';

final class LoginState {
  final LoginEmailField email;
  final LoginPasswordField password;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String toastMessage;

  const LoginState({
    this.email = const LoginEmailField.pure(),
    this.password = const LoginPasswordField.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.toastMessage = '',
  });

  LoginState copyWith({
    LoginEmailField? email,
    LoginPasswordField? password,
    bool? isValid,
    FormzSubmissionStatus? status,
    String? toastMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }
}

final class LoginInitial extends LoginState {}
