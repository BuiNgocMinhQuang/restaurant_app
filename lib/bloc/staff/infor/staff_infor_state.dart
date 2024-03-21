part of 'staff_infor_bloc.dart';

class StaffInforState extends Equatable {
  const StaffInforState(
      {this.staffInforStatus, this.errorText, this.staffInforDataModel});

  final StaffInfor? staffInforDataModel;
  final StaffInforStatus? staffInforStatus;
  final String? errorText;

  StaffInforState copyWith({
    StaffInforStatus? staffInforStatus,
    String? errorText,
    StaffInfor? staffInforDataModel,
  }) {
    return StaffInforState(
      staffInforStatus: staffInforStatus ?? this.staffInforStatus,
      errorText: errorText ?? this.errorText,
      staffInforDataModel: staffInforDataModel ?? this.staffInforDataModel,
    );
  }

  @override
  List<Object?> get props => [errorText, staffInforDataModel, staffInforStatus];
}

enum StaffInforStatus { loading, success, failed }
