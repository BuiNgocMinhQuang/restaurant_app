part of 'manager_login_bloc.dart';

abstract class ManagerLoginEvent extends Equatable {
  const ManagerLoginEvent();
}

class ManagerLoginButtonPressed extends ManagerLoginEvent {
  final String email;
  final String password;

  const ManagerLoginButtonPressed({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [];
}

class ManagerLogout extends ManagerLoginEvent {
  const ManagerLogout();
  @override
  List<Object> get props => [];
}
