part of 'manager_register_bloc.dart';

class ManagerRegisterState extends Equatable {
  const ManagerRegisterState({
    this.managerRegisterStatus,
    this.errorText,
  });

  final ManagerRegisterStatus? managerRegisterStatus;
  final String? errorText;

  ManagerRegisterState copyWith({
    ManagerRegisterStatus? managerRegisterStatus,
    String? errorText,
  }) {
    return ManagerRegisterState(
      managerRegisterStatus:
          managerRegisterStatus ?? this.managerRegisterStatus,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [managerRegisterStatus, errorText];
}

enum ManagerRegisterStatus { loading, success, failed }
