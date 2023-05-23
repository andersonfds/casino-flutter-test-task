abstract class CharacterListEvent {}

/// Whenever emmitted the bloc will fetch the items on [page]
class CharacterListFetchEvent extends CharacterListEvent {
  final int page;

  CharacterListFetchEvent(this.page);

  factory CharacterListFetchEvent.initial() => CharacterListFetchEvent(1);

  factory CharacterListFetchEvent.next(int page) =>
      CharacterListFetchEvent(page);
}

/// Will be emitted whenever the network state changes
/// [isOnline] will be true if data network is available
class CharacterNetworkEvent extends CharacterListEvent {
  final bool isOnline;

  CharacterNetworkEvent(this.isOnline);

  factory CharacterNetworkEvent.initial() => CharacterNetworkEvent(true);
}

/// Will be emitted whenever the user reaches the end of the list
class OnEdgeHitEvent extends CharacterListEvent {}
