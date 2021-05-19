import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
import 'package:spotify_clone/constants/enums.dart';

part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  final Connectivity connectivity;
  StreamSubscription connectivityStreamSubscription;

  InternetConnectionCubit({
    @required this.connectivity,
  }) : super(InternetConnectionInitial()) {
    monitorInternetConnection();
  }

  StreamSubscription<ConnectivityResult> monitorInternetConnection() {
    return connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        print('connection: Wifi');
        emit(InternetConnectedState(connectionType: ConnectionType.Wifi));
      } else if (connectivityResult == ConnectivityResult.mobile) {
        print('connection: Mobile');
        emit(InternetConnectedState(connectionType: ConnectionType.Mobile));
      } else if (connectivityResult == ConnectivityResult.none) {
        emit(InternetDisconnectedState());
        print('connection: none');
      }
    });
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
