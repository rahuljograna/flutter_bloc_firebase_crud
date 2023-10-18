import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/user_model.dart';
import 'package:flutter_bloc_firebase_crud/app/core/repositories/auth_repository.dart';
import 'package:flutter_bloc_firebase_crud/app/core/validations/login_form.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AuthRepository();
  LoginBloc() : super(LoginInitial()) {
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginEmailUnfocused>(_onLoginEmailUnfocused);
    on<LoginPasswordUnfocused>(_onLoginPasswordUnfocused);

    on<LoginFormSubmitted>(_onLoginFormSubmitted);
  }

  void _onLoginEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = LoginEmailField.dirty(event.email);
    emit(
      state.copyWith(
        email: email.isValid ? email : LoginEmailField.pure(event.email),
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onLoginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = LoginPasswordField.dirty(event.password);
    emit(
      state.copyWith(
        password: password.isValid
            ? password
            : LoginPasswordField.pure(event.password),
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  void _onLoginEmailUnfocused(
      LoginEmailUnfocused event, Emitter<LoginState> emit) {
    final email = LoginEmailField.dirty(state.email.value);
    emit(
      state.copyWith(
        email: email,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onLoginPasswordUnfocused(
    LoginPasswordUnfocused event,
    Emitter<LoginState> emit,
  ) {
    final password = LoginPasswordField.dirty(state.password.value);
    emit(
      state.copyWith(
        password: password,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> _onLoginFormSubmitted(
    LoginFormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = LoginEmailField.dirty(state.email.value);
    final password = LoginPasswordField.dirty(state.password.value);
    emit(
      state.copyWith(
        email: email,
        password: password,
        status: FormzSubmissionStatus.initial,
        isValid: Formz.validate([email, password]),
      ),
    );
    if (state.isValid &&
        state.email.value.isNotEmpty &&
        state.password.value.isNotEmpty) {
      UserModel user = UserModel(
        email: state.email.value.toString(),
        password: state.password.value.toString(),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        UserCredential? authUser = await _authRepository.signIn(user);
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
