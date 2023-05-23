import 'package:equatable/equatable.dart';

abstract class MainPageEvent extends Equatable {
  const MainPageEvent();

  @override
  List<Object?> get props => [];
}

class MainPageFetch extends MainPageEvent {
  final int page;

  MainPageFetch(this.page);

  factory MainPageFetch.initial() => MainPageFetch(1);

  factory MainPageFetch.next(int page) => MainPageFetch(page);

  @override
  List<Object?> get props => [page];
}

class NetworkChanged extends MainPageEvent {
  NetworkChanged();

  @override
  List<Object?> get props => [];
}

class OnNetworkRestored extends MainPageEvent {}
