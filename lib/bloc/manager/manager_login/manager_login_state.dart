part of 'manager_login_bloc.dart';

class ManagerLoginState extends Equatable {
  const ManagerLoginState({
    this.loginStatus,
    this.errorText,
    this.managerInforModel,
    this.listStoreModel,
  });

  final ManagerLoginStatus? loginStatus;
  final String? errorText;
  final ManagerInforModel? managerInforModel;
  final ListStoreModel? listStoreModel;
  ManagerLoginState copyWith(
      {ManagerLoginStatus? loginStatus,
      String? errorText,
      ManagerInforModel? managerInforModel,
      ListStoreModel? listStoreModel}) {
    return ManagerLoginState(
        loginStatus: loginStatus ?? this.loginStatus,
        errorText: errorText ?? this.errorText,
        managerInforModel: managerInforModel ?? this.managerInforModel,
        listStoreModel: listStoreModel ?? this.listStoreModel);
  }

  @override
  List<Object?> get props =>
      [loginStatus, errorText, managerInforModel, listStoreModel];
}

enum ManagerLoginStatus { loading, success, failed }
