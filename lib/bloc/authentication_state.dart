part of 'authentication_bloc.dart';

//responsible for the authentication process's different states
//direct to homepage/onboarding screen

abstract class AuthenticationState {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

// authentication process is in progress
// show loading screen
class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;
  AuthenticationLoadingState({required this.isLoading});
}

//authentication process has been completed
class AuthenticationSuccessState extends AuthenticationState {
  // Replace 'path_to_user_model.dart' with the actual path to the UserModel class.
  final UserModel user;
  const AuthenticationSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;
  const AuthenticationFailureState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
