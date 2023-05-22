import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/enum/main_status.dart';
import 'package:casino_test/src/presentation/bloc/main_bloc.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:casino_test/src/presentation/widgets/character_card.dart';
import 'package:casino_test/src/presentation/widgets/endless_scrolling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@immutable
class CharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainPageBloc(
        InitialLoadingPageState(),
        GetIt.I.get<CharactersRepository>(),
        GetIt.I.get<NetworkCheckProvider>(),
      ),
      child: _CharacterView(),
    );
  }
}

class _CharacterView extends StatefulWidget {
  const _CharacterView({Key? key}) : super(key: key);

  @override
  State<_CharacterView> createState() => __CharacterViewState();
}

class __CharacterViewState extends State<_CharacterView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<MainPageBloc>(context);
    bloc.add(NetworkChanged());
    bloc.add(MainPageFetch(1));
  }

  void _setUpSnackBar(MainStatus status) {
    if (status == MainStatus.offline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection'),
          showCloseIcon: true,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MainPageBloc, MainPageState>(
        listener: (context, state) {
          _setUpSnackBar(state.status);
        },
        builder: (blocContext, state) {
          if (state is InitialLoadingPageState) {
            return const _LoadingDataView();
          }

          return _CharacterCardListView(state: state);
        },
      ),
    );
  }
}

class _CharacterCardListView extends StatelessWidget {
  const _CharacterCardListView({
    required this.state,
    Key? key,
  }) : super(key: key);

  final MainPageState state;

  @override
  Widget build(BuildContext context) {
    final characters = state.characters;

    return EndlessScrolling(
      onEdge: () async {
        final bloc = BlocProvider.of<MainPageBloc>(context);
        bloc.add(MainPageFetch(state.page + 1));
      },
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
            child: Center(
              child: Opacity(
                opacity: state.status == MainStatus.loading ? 1 : 0,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDataView extends StatelessWidget {
  const _LoadingDataView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
