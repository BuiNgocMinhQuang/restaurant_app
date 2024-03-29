part of 'manager_login_bloc.dart';

class ManagerLoginState extends Equatable {
  const ManagerLoginState(
      {this.loginStatus, this.errorText, this.managerInforModel});

  final ManagerLoginStatus? loginStatus;
  final String? errorText;
  final ManagerInforModel? managerInforModel;

  ManagerLoginState copyWith(
      {ManagerLoginStatus? loginStatus,
      String? errorText,
      ManagerInforModel? managerInforModel}) {
    return ManagerLoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      errorText: errorText ?? this.errorText,
      managerInforModel: managerInforModel ?? this.managerInforModel,
    );
  }

  @override
  List<Object?> get props => [loginStatus, errorText, managerInforModel];
}

enum ManagerLoginStatus { loading, success, failed, logged }
