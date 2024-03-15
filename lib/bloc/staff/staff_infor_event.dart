part of 'staff_infor_bloc.dart';

abstract class StaffInforEvent extends Equatable {
  const StaffInforEvent();
}

// class LoginAppInit extends StaffInforEvent {
//   const LoginAppInit();

//   @override
//   List<Object> get props => [];
// }

class GetStaffInfor extends StaffInforEvent {
  const GetStaffInfor();
  @override
  List<Object> get props => [];
}

// class ManagerStaffLoginButtonPressed extends StaffInforEvent {
//   final String email;
//   final String password;

//   const ManagerStaffLoginButtonPressed({
//     required this.email,
//     required this.password,
//   });
//   @override
//   List<Object> get props => [];
// }

// class LogoutStaff extends StaffInforEvent {
//   const LogoutStaff();
//   @override
//   List<Object> get props => [];
// }
