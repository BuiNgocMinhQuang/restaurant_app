part of 'manager_login_bloc.dart';

abstract class ManagerLoginEvent extends Equatable {
  const ManagerLoginEvent();
}

class ManagerLoginButtonPressed extends ManagerLoginEvent {
  final String email;
  final String password;
  final bool remember;

  const ManagerLoginButtonPressed({
    required this.email,
    required this.password,
    required this.remember,
  });
  @override
  List<Object> get props => [];
}

class ManagerLogout extends ManagerLoginEvent {
  const ManagerLogout();
  @override
  List<Object> get props => [];
}
