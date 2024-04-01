part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginAppInit extends LoginEvent {
  const LoginAppInit();

  @override
  List<Object> get props => [];
}

class StaffLoginButtonPressed extends LoginEvent {
  final String shopId;
  final String email;
  final String password;
  final bool remember;

  const StaffLoginButtonPressed(
      {required this.shopId,
      required this.email,
      required this.password,
      required this.remember});
  @override
  List<Object> get props => [];
}

class LogoutStaff extends LoginEvent {
  const LogoutStaff();
  @override
  List<Object> get props => [];
}

class ConfirmLogged extends LoginEvent {
  const ConfirmLogged();
  @override
  List<Object> get props => [];
}
