part of 'staff_login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String shopId;
  final String email;
  final String password;

  LoginButtonPressed({
    required this.shopId,
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [shopId, email, password];
}
