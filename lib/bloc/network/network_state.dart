part of 'network_cubit.dart';

enum ConnectivityStatus { connected, disconnected }

class InternetStatus {
  final ConnectivityStatus status;
  const InternetStatus(this.status);
}
