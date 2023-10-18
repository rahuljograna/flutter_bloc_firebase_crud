part of 'register_bloc.dart';

sealed class RegisterEvent {}

final class RegisterEmailChanged extends RegisterEvent {
  final String email;

  RegisterEmailChanged({required this.email});
}

final class RegisterEmailUnfocused extends RegisterEvent {}

final class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  RegisterPasswordChanged({required this.password});
}

final class RegisterPasswordUnfocused extends RegisterEvent {}

final class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String password;

  RegisterConfirmPasswordChanged({required this.password});
}

final class RegisterConfirmPasswordUnfocused extends RegisterEvent {}

final class RegisterNameChanged extends RegisterEvent {
  final String name;

  RegisterNameChanged({required this.name});
}

final class RegisterNameUnfocused extends RegisterEvent {}

final class RegisterFormSubmitted extends RegisterEvent {}
