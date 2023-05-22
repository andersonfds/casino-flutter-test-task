import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_check_provider.dart';

class NetworkCheckProviderImpl implements NetworkCheckProvider {
  final InternetConnectionChecker _connectivity;

  NetworkCheckProviderImpl(this._connectivity);

  @override
  Future<bool> isOnline() async {
    final result = await _connectivity.connectionStatus;
    return result.isOnline;
  }

  @override
  Stream<bool> get networkState => _connectivity.onStatusChange.map((event) {
        return event.isOnline;
      });
}

extension ConnectivityResultX on InternetConnectionStatus {
  bool get isOnline => this == InternetConnectionStatus.connected;
}
