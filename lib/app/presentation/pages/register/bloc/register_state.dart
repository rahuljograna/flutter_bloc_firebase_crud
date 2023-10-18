part of 'register_bloc.dart';

final class RegisterState {
  final RegisterEmailField email;
  final RegisterPasswordField password;
  final RegisterConfirmedPasswordField confirmedPassword;
  final RegisterNameField name;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String toastMessage;

  const RegisterState({
    this.email = const RegisterEmailField.pure(),
    this.password = const RegisterPasswordField.pure(),
    this.confirmedPassword = const RegisterConfirmedPasswordField.pure(),
    this.name = const RegisterNameField.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.toastMessage = '',
  });

  RegisterState copyWith({
    RegisterEmailField? email,
    RegisterPasswordField? password,
    RegisterConfirmedPasswordField? confirmedPassword,
    RegisterNameField? name,
    bool? isValid,
    FormzSubmissionStatus? status,
    String? toastMessage,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      name: name ?? this.name,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }
}

final class RegisterInitial extends RegisterState {}
