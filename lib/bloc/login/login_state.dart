part of 'login_bloc.dart';

// abstract class LoginState extends Equatable {
//   const LoginState();
//   @override
//   List<Object> get props => [];
// }

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginSuccess extends LoginState {}

// class AuthenticationSuccess extends LoginState {
//   final String token;

//   const AuthenticationSuccess(this.token);

//   @override
//   List<Object> get props => [token];
// }

// class LoginFailure extends LoginState {
//   final String message;

//   LoginFailure(this.message);
// }

class LoginState extends Equatable {
  const LoginState({
    this.authDataModel,
    this.loginStatus,
    this.errorText,
  });

  final AuthDataModel? authDataModel;
  final LoginStatus? loginStatus;
  final String? errorText;

  LoginState copyWith(
      {LoginStatus? loginStatus,
      AuthDataModel? authDataModel,
      String? errorText}) {
    return LoginState(
      authDataModel: authDataModel ?? this.authDataModel,
      loginStatus: loginStatus ?? this.loginStatus,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [
        authDataModel,
        loginStatus,
        errorText,
      ];
}

enum LoginStatus {
  loading,
  success,
  failed,
}
