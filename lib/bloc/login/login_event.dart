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
  final bool remember;

  const LoginButtonPressed(
      {required this.shopId,
      required this.email,
      required this.password,
      required this.remember});
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

class LogoutStaff extends LoginEvent {
  const LogoutStaff();
  @override
  List<Object> get props => [];
}
