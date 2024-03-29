part of 'manager_register_bloc.dart';

abstract class ManagerRegisterEvent extends Equatable {
  const ManagerRegisterEvent();
}

class ManagerRegisterButtonPressed extends ManagerRegisterEvent {
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String confirmPassword;
  final bool agreeConditon;

  const ManagerRegisterButtonPressed({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.confirmPassword,
    required this.agreeConditon,
  });
  @override
  List<Object> get props => [];
}
