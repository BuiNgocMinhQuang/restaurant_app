part of 'list_stores_bloc.dart';

class ListStoresState extends Equatable {
  const ListStoresState(
      {this.listStoresStatus, this.listStoreModel, this.errorText});
  final ListStoreModel? listStoreModel;
  final ListStoresStatus? listStoresStatus;
  final String? errorText;

  ListStoresState copyWith(
      {ListStoreModel? listStoreModel,
      ListStoresStatus? listStoresStatus,
      String? errorText}) {
    return ListStoresState(
        listStoreModel: listStoreModel ?? this.listStoreModel,
        listStoresStatus: listStoresStatus ?? this.listStoresStatus,
        errorText: errorText ?? this.errorText);
  }

  @override
  List<Object?> get props => [listStoreModel, listStoresStatus, errorText];
}

enum ListStoresStatus { loading, succes, failed }
