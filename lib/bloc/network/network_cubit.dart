// import 'package:bloc/bloc.dart';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'network_state.dart';

class InternetCubit extends Cubit<InternetStatus> {
  InternetCubit()
      : super(const InternetStatus(ConnectivityStatus.disconnected));

  void checkConectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    updateConnectivityStatus(connectivityResult);
  }

  void updateConnectivityStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      emit(const InternetStatus(ConnectivityStatus.disconnected));
    } else {
      emit(const InternetStatus(ConnectivityStatus.connected));
    }
  }

  StreamSubscription<ConnectivityResult>? subscription;

  void trackConnectivityChange() {
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      updateConnectivityStatus(result);
    });
  }

  void disposeInternet() {
    subscription!.cancel();
  }
}
