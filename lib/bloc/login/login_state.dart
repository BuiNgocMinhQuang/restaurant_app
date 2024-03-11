part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState(
      {this.authDataModel,
      this.loginStatus,
      this.errorText,
      this.staffInforDataModel});

  final AuthDataModel? authDataModel;
  final LoginStatus? loginStatus;
  final String? errorText;
  final StaffInfor? staffInforDataModel;

  LoginState copyWith(
      {LoginStatus? loginStatus,
      AuthDataModel? authDataModel,
      String? errorText,
      StaffInfor? staffInforDataModel}) {
    return LoginState(
        authDataModel: authDataModel ?? this.authDataModel,
        loginStatus: loginStatus ?? this.loginStatus,
        errorText: errorText ?? this.errorText,
        staffInforDataModel: staffInforDataModel ?? this.staffInforDataModel);
  }

  @override
  List<Object?> get props =>
      [authDataModel, loginStatus, errorText, staffInforDataModel];
}

enum LoginStatus { loading, success, failed, logged }
