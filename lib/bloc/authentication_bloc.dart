import 'package:astridzhao_s_food_app/resources/firebasestore.dart';
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
          await FirebaseAuth.instance.currentUser?.reload();
          print(
              "email verified ${FirebaseAuth.instance.currentUser?.emailVerified}");
          if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
            print("Emitting SignUpSuccessState");
            // await Storedata(user.id).updateUserSubscription(customerInfo);
            emit(SignUpSuccessState(user));
          } else {
            print("Emitting SignUpNeedsVerificationState");
            emit(SignUpNeedsVerificationState(event.email));
          }
        } else {
          emit(SignUpFailureState('An unknown error occurred'));
        }
      } on FirebaseAuthException catch (e) {
        emit(SignUpFailureState(e.message ?? 'An unknown error occurred'));
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
          // User is successfully signed in and not null
          emit(SignInSuccessState(user));
        } else {
          // Handle the case where user is null - maybe emit a different state
          // or a failure state with a specific error message
          emit(SignInFailureState('Authentication failed. Please try again.'));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password provided for that user.';
            break;
          case 'user-disabled':
            errorMessage = 'The user account has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests. Try again later.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Signing in with email and password is not enabled.';
            break;
          default:
            errorMessage = 'An unexpected error occurred. Please try again.';
        }

        emit(SignInFailureState(e.message! + errorMessage));
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
        emit(SignOutSuccessState());
      } catch (e) {
        print('error');
        print(e.toString());
        emit(SignOutFailureState(e.toString()));
      }
      emit(SignOutLoadingState(isLoading: false));
    });
  }
}
