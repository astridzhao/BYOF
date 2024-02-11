part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class SignUpUser extends AuthenticationEvent {
  final String email;
  final String password;
  final bool emailVerified;

  const SignUpUser(this.email, this.password, {this.emailVerified = false});

  @override
  List<Object> get props => [email, password, emailVerified];

  String toString() => 'SignUpSuccessState(emailVerified: $emailVerified)';
}

class SignInUser extends AuthenticationEvent {
  final String email;
  final String password;
  const SignInUser(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

//updating the authentication state accordingly
class SignOut extends AuthenticationEvent {}
