import 'package:casino_test/src/data/providers/network_check_provider.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/enum/main_status.dart';
import 'package:casino_test/src/presentation/bloc/main_bloc.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:casino_test/src/presentation/widgets/character_card.dart';
import 'package:casino_test/src/presentation/widgets/endless_scrolling.dart';
import 'package:casino_test/src/presentation/widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
  late MainPageBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<MainPageBloc>(context);
    _bloc.add(NetworkChanged());
    _bloc.add(MainPageFetch.initial());
  }

  void _onNetworkRetry() {
    _bloc.add(MainPageFetch.initial());
  }

  void _setUpSnackBar(MainStatus status) {
    if (status == MainStatus.offline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
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
      appBar: AppBar(
        title: Hero(
          tag: 'logo',
          transitionOnUserGestures: true,
          child: SvgPicture.asset(
            'assets/images/logo_rnm.svg',
            height: 40,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      body: BlocConsumer<MainPageBloc, MainPageState>(
        listener: (context, state) {
          _setUpSnackBar(state.status);
        },
        builder: (blocContext, state) {
          if (state.characters.isNotEmpty) {
            return _CharacterCardListView(state: state);
          }

          if (state.status == MainStatus.failure) {
            return NoInternetWidget(onRetry: _onNetworkRetry);
          }

          return const _LoadingDataView();
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
    final hasNextPage = state.hasNextPage;
    final isLoading = state.status == MainStatus.loading;

    return EndlessScrolling(
      onEdge: () async {
        if (hasNextPage) {
          final bloc = BlocProvider.of<MainPageBloc>(context);
          bloc.add(MainPageFetch.next(state.next()));
        }
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
                opacity: isLoading ? 1 : 0,
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
