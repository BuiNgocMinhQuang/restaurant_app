part of 'list_room_bloc.dart';

abstract class ListRoomEvent extends Equatable {
  const ListRoomEvent();
}

class GetListRoom extends ListRoomEvent {
  final String token;
  final String client;
  final String shopId;
  final bool isApi;
  final String roomId;

  const GetListRoom({
    required this.token,
    required this.client,
    required this.shopId,
    this.isApi = true,
    this.roomId = "",
  });

  @override
  List<Object> get props => [];
}
