import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/screens/character_list/bloc/bloc.dart';
import 'package:casino_test/src/presentation/screens/character_list/bloc/event.dart';
import 'package:casino_test/src/presentation/screens/character_list/bloc/state.dart';
import 'package:casino_test/src/presentation/widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../widgets/character_card.dart';
import '../../widgets/endless_scrolling.dart';
import '../../widgets/loading_center_widget.dart';
import '../../widgets/rick_and_morty_logo.dart';

@immutable
class CharacterListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterListBloc(
        initialCharacterListPageState,
        GetIt.I.get<CharactersRepository>(),
        GetIt.I.get<NetworkCheckProvider>(),
      ),
      child: _CharacterListPageView(),
    );
  }
}

class _CharacterListPageView extends StatefulWidget {
  const _CharacterListPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<_CharacterListPageView> createState() => _CharacterListPageViewState();
}

class _CharacterListPageViewState extends State<_CharacterListPageView> {
  late CharacterListBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<CharacterListBloc>(context);
    _bloc.add(CharacterListFetchEvent.initial());
    _bloc.add(CharacterNetworkEvent.initial());
  }

  void _onEdgeHit() {
    _bloc.add(OnEdgeHitEvent());
  }

  void _onStatusChanged(CharacterListPageStatus status) {
    if (status.isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (status.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (status.isSuccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: RickAndMortyLogo()),
      body: BlocConsumer<CharacterListBloc, CharacterListPageState>(
        listener: (context, state) {
          _onStatusChanged(state.status);
        },
        builder: (context, state) {
          final hasCharacters = state.characters.isNotEmpty;
          final currentStatus = state.status;

          if (currentStatus.isLoading && !hasCharacters) {
            return LoadingDataView();
          }

          if (currentStatus.isFailure && !hasCharacters) {
            return NoInternetWidget(
              onRetry: () => _bloc.add(CharacterListFetchEvent.initial()),
            );
          }

          return _CharacterCardListView(
            onEdge: _onEdgeHit,
            characters: state.characters,
            loading: currentStatus.isLoading,
          );
        },
      ),
    );
  }
}

class _CharacterCardListView extends StatelessWidget {
  const _CharacterCardListView({
    required this.characters,
    required this.loading,
    this.onEdge,
    Key? key,
  }) : super(key: key);

  final List<Character> characters;
  final bool loading;
  final VoidCallback? onEdge;

  @override
  Widget build(BuildContext context) {
    return EndlessScrolling(
      onEdge: onEdge,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final character = characters[index];
                return CharacterCard(
                  character: character,
                );
              },
              childCount: characters.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: loading,
              child: LoadingDataView(),
            ),
          ),
        ],
      ),
    );
  }
}
