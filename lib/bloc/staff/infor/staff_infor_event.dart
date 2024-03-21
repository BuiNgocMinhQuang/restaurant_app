part of 'staff_infor_bloc.dart';

abstract class StaffInforEvent extends Equatable {
  const StaffInforEvent();
}

class GetStaffInfor extends StaffInforEvent {
  const GetStaffInfor();
  @override
  List<Object> get props => [];
}
