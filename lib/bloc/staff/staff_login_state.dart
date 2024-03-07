part of 'staff_login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class AuthenticationSuccess extends LoginState {
  final String token;

  const AuthenticationSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
