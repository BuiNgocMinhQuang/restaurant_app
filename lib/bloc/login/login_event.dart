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

  LoginButtonPressed({
    required this.shopId,
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [shopId, email, password];
}

class LoginStaffAuthData extends LoginEvent {
  const LoginStaffAuthData(this.authDataModel);

  final AuthDataModel authDataModel;

  @override
  List<Object> get props => [authDataModel];
}
