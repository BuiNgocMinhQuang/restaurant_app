part of 'list_stores_bloc.dart';

abstract class ListStoresEvent extends Equatable {
  const ListStoresEvent();
}

class GetListStores extends ListStoresEvent {
  final String token;

  const GetListStores({
    required this.token,
  });

  @override
  List<Object> get props => [];
}
