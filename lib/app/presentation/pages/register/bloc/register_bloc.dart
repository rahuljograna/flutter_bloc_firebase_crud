import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/user_model.dart';
import 'package:flutter_bloc_firebase_crud/app/core/repositories/auth_repository.dart';
import 'package:flutter_bloc_firebase_crud/app/core/validations/register_form.dart';
import 'package:formz/formz.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository = AuthRepository();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEmailChanged>(_onRegisterEmailChanged);
    on<RegisterPasswordChanged>(_onRegisterPasswordChanged);
    on<RegisterNameChanged>(_onRegisterNameChanged);
    on<RegisterConfirmPasswordChanged>(_onRegisterConfirmPasswordChanged);

    on<RegisterEmailUnfocused>(_onRegisterEmailUnfocused);
    on<RegisterPasswordUnfocused>(_onRegisterPasswordUnfocused);
    on<RegisterNameUnfocused>(_onRegisterNameUnfocused);
    on<RegisterConfirmPasswordUnfocused>(_onRegisterConfirmPasswordUnfocused);

    on<RegisterFormSubmitted>(_onRegisterFormSubmitted);
  }

  Future<void> _onRegisterEmailChanged(
      RegisterEmailChanged event, Emitter<RegisterState> emit) async {
    final email = RegisterEmailField.dirty(event.email);
    emit(
      state.copyWith(
        email: email.isValid ? email : RegisterEmailField.pure(event.email),
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          email,
          state.password,
          state.name,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onRegisterPasswordChanged(
      RegisterPasswordChanged event, Emitter<RegisterState> emit) async {
    final password = RegisterPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        password: password.isValid
            ? password
            : RegisterPasswordField.pure(event.password),
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          password,
          state.email,
          state.name,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onRegisterNameChanged(
      RegisterNameChanged event, Emitter<RegisterState> emit) async {
    final name = RegisterNameField.dirty(event.name);
    emit(
      state.copyWith(
        name: name.isValid ? name : RegisterNameField.pure(event.name),
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onRegisterConfirmPasswordChanged(
      RegisterConfirmPasswordChanged event, Emitter<RegisterState> emit) async {
    final confirmedPassword = RegisterConfirmedPasswordField.dirty(
      password: state.confirmedPassword.value,
      value: event.password,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          confirmedPassword,
          state.password,
          state.name,
          state.email,
        ]),
      ),
    );
  }

  Future<void> _onRegisterEmailUnfocused(
      RegisterEmailUnfocused event, Emitter<RegisterState> emit) async {
    final email = RegisterEmailField.dirty(state.email.value);
    emit(
      state.copyWith(
        email: email,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          email,
          state.password,
          state.name,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onRegisterPasswordUnfocused(
      RegisterPasswordUnfocused event, Emitter<RegisterState> emit) async {
    final password = RegisterPasswordField.dirty(state.password.value);
    emit(
      state.copyWith(
        password: password,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          password,
          state.email,
          state.name,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onRegisterNameUnfocused(
      RegisterNameUnfocused event, Emitter<RegisterState> emit) async {
    final name = RegisterNameField.dirty(state.name.value);
    emit(
      state.copyWith(
        name: name,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          name,
          state.email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onRegisterConfirmPasswordUnfocused(
      RegisterConfirmPasswordUnfocused event,
      Emitter<RegisterState> emit) async {
    final confirmedPassword = RegisterConfirmedPasswordField.dirty(
        password: state.password.value, value: state.confirmedPassword.value);
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([
          confirmedPassword,
          state.email,
          state.password,
          state.name,
        ]),
      ),
    );
  }

  Future<void> _onRegisterFormSubmitted(
      RegisterFormSubmitted event, Emitter<RegisterState> emit) async {
    final email = RegisterEmailField.dirty(state.email.value);
    final password = RegisterPasswordField.dirty(state.password.value);
    final name = RegisterNameField.dirty(state.name.value);
    final confirmPassword = RegisterConfirmedPasswordField.dirty(
        password: state.password.value, value: state.confirmedPassword.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        name: name,
        confirmedPassword: confirmPassword,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([email, password, name, confirmPassword]),
      ),
    );
    if (state.isValid) {
      debugPrint('Submit => ${state.email.value.toString()}');
      debugPrint('name => ${state.name.value}');
      debugPrint('password => ${state.password.value}');
      debugPrint('confirm => ${state.confirmedPassword.value}');
      UserModel user = UserModel(
        email: state.email.value.toString(),
        password: state.password.value.toString(),
        displayName: state.name.value.toString(),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        UserCredential? authUser = await _authRepository.signUp(user);
        debugPrint('auth user ${authUser!.user!.email}');
        await _authRepository.saveUID(authUser.user!.uid);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on FirebaseAuthException catch (e) {
        debugPrint(e.message.toString());
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          toastMessage: e.message.toString(),
        ));
      }
    }
  }
}
