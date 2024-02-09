import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'package:astridzhao_s_food_app/user.dart';
import 'package:astridzhao_s_food_app/services/authentication.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignUpUser>((event, emit) async {
      //It emits an  AuthenticationLoadingState to indicate that the authentication process is in progress.
      emit(SignUpLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signUpUser(event.email, event.password);
        if (user != null) {
          emit(SignUpSuccessState(user));
        } else {
          emit(SignUpFailureState('An unknown error occurred'));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('weak-password');
          emit(SignUpFailureState('The password provided is too weak.'));
        } else if (e.code == 'email-already-in-use') {
          emit(
              SignUpFailureState('The account already exists for this email.'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(SignUpLoadingState(isLoading: false));
    });

    on<SignInUser>((event, emit) async {
      emit(SignInLoadingState(isLoading: true));
      try {
        final UserModel? user =
            await authService.signInUser(event.email, event.password);
        if (user != null) {
          emit(SignInSuccessState(user));
        } else {
          emit(SignInFailureState('Check your email and password.'));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(SignInFailureState('No user found for this email.'));
          print('No user found for this email.');
        } else if (e.code == 'wrong-password') {
          emit(SignInFailureState('Wrong Password.'));
          print('Wrong Password.');
        } else {
          emit(SignInFailureState('An unknown error occurred'));
        }
      } catch (e) {
        // Handle any other errors
        emit(SignInFailureState(e.toString()));
      }
      emit(SignInLoadingState(isLoading: false));
    });

    on<SignOut>((event, emit) async {
      emit(SignOutLoadingState(isLoading: true));
      try {
        authService.signOutUser();
      } catch (e) {
        print('error');
        print(e.toString());
      }
      emit(SignOutLoadingState(isLoading: false));
    });
  }
}
