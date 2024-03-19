part of 'bill_bloc.dart';

class BillInforState extends Equatable {
  const BillInforState({this.errorText, this.billStatus, this.billInforModel});

  final String? errorText;
  final BillInforStateStatus? billStatus;
  final BillInforModel? billInforModel;

  BillInforState copyWith(
      {String? errorText,
      BillInforStateStatus? billStatus,
      BillInforModel? billInforModel}) {
    return BillInforState(
        errorText: errorText ?? this.errorText,
        billStatus: billStatus ?? this.billStatus,
        billInforModel: billInforModel ?? this.billInforModel);
  }

  @override
  List<Object?> get props => [errorText, billStatus, billInforModel];
}

enum BillInforStateStatus { loading, succes, failed }
