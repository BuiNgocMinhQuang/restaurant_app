part of 'staff_login_bloc.dart';

class LoginState extends Equatable {
  const LoginState(
      {this.authDataModel,
      this.loginStatus,
      this.errorText,
      this.staffInforDataModel,
      this.managerInforModel});

  final StaffAuthData? authDataModel;
  final LoginStatus? loginStatus;
  final String? errorText;
  final StaffInfor? staffInforDataModel;
  final ManagerInforModel? managerInforModel;

  LoginState copyWith(
      {LoginStatus? loginStatus,
      StaffAuthData? authDataModel,
      String? errorText,
      StaffInfor? staffInforDataModel,
      ManagerInforModel? managerInforModel}) {
    return LoginState(
      authDataModel: authDataModel ?? this.authDataModel,
      loginStatus: loginStatus ?? this.loginStatus,
      errorText: errorText ?? this.errorText,
      staffInforDataModel: staffInforDataModel ?? this.staffInforDataModel,
      managerInforModel: managerInforModel ?? this.managerInforModel,
    );
  }

  @override
  List<Object?> get props => [
        authDataModel,
        loginStatus,
        errorText,
        staffInforDataModel,
        managerInforModel
      ];
}

enum LoginStatus { loading, success, failed, logged }
