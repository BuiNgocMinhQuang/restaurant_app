part of 'list_room_bloc.dart';

class ListRoomState extends Equatable {
  const ListRoomState(
      {this.listRoomStatus, this.listRoomModel, this.errorText});
  final ListRoomModel? listRoomModel;
  final ListRoomStatus? listRoomStatus;
  final String? errorText;

  ListRoomState copyWith(
      {ListRoomModel? listRoomModel,
      ListRoomStatus? listRoomStatus,
      String? errorText}) {
    return ListRoomState(
        listRoomModel: listRoomModel ?? this.listRoomModel,
        listRoomStatus: listRoomStatus ?? this.listRoomStatus,
        errorText: errorText ?? this.errorText);
  }

  @override
  List<Object?> get props => [listRoomModel, listRoomStatus, errorText];
}

enum ListRoomStatus { loading, succes, failed }
