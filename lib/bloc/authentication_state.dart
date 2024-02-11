part of 'authentication_bloc.dart';

abstract class AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

// Loading States
class SignUpLoadingState extends AuthenticationState {
  final bool isLoading;
  SignUpLoadingState({required this.isLoading});
}

class SignInLoadingState extends AuthenticationState {
  final bool isLoading;
  SignInLoadingState({required this.isLoading});
}

class SignOutLoadingState extends AuthenticationState {
  final bool isLoading;
  SignOutLoadingState({required this.isLoading});
}

// Success States
class AuthenticationSuccessState extends AuthenticationState {
  final UserModel user;
  AuthenticationSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpSuccessState extends AuthenticationState {
  final UserModel user;
  SignUpSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpNeedsVerificationState extends AuthenticationState {
  final String email;
  SignUpNeedsVerificationState(this.email);
}

class SignInSuccessState extends AuthenticationState {
  final UserModel user;
  SignInSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class SignOutSuccessState extends AuthenticationState {
  SignOutSuccessState();
}

// Failure States

class SignUpFailureState extends AuthenticationState {
  final String errorMessage;
  SignUpFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class SignInFailureState extends AuthenticationState {
  final String errorMessage;
  SignInFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class SignOutFailureState extends AuthenticationState {
  final String errorMessage;
  SignOutFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
