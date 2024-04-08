part of 'manager_login_bloc.dart';

class ManagerLoginState extends Equatable {
  const ManagerLoginState({
    this.loginStatus,
    this.errorText,
  });

  final ManagerLoginStatus? loginStatus;
  final String? errorText;
  ManagerLoginState copyWith({
    ManagerLoginStatus? loginStatus,
    String? errorText,
  }) {
    return ManagerLoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [loginStatus, errorText];
}

enum ManagerLoginStatus { loading, success, failed }
