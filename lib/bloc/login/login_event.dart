part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginAppInit extends LoginEvent {
  const LoginAppInit();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String shopId;
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.shopId,
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [];
}

class ManagerLoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const ManagerLoginButtonPressed({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [];
}
