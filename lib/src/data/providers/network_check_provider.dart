abstract class NetworkCheckProvider {
  Future<bool> isOnline();

  Stream<bool> get networkState;
}
