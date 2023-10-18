part of 'login_bloc.dart';

sealed class LoginEvent {}

final class LoginEmailChanged extends LoginEvent {
  final String email;

  LoginEmailChanged({required this.email});
}

final class LoginEmailUnfocused extends LoginEvent {}

final class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

final class LoginPasswordUnfocused extends LoginEvent {}

final class LoginFormSubmitted extends LoginEvent {}
