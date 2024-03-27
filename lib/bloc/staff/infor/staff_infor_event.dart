part of 'staff_infor_bloc.dart';

abstract class StaffInforEvent extends Equatable {
  const StaffInforEvent();
}

class GetStaffInfor extends StaffInforEvent {
  const GetStaffInfor();
  @override
  List<Object> get props => [];
}

class GetAddressInfor extends StaffInforEvent {
  final int? city;
  final int? district;

  const GetAddressInfor({
    required this.city,
    required this.district,
  });

  @override
  List<Object> get props => [];
}
