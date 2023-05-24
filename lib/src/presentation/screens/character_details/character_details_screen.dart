import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/presentation/widgets/rick_and_morty_logo.dart';
import 'package:flutter/material.dart';

class CharacterDetailsScreen extends StatefulWidget {
  const CharacterDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late Character _character;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _character = ModalRoute.of(context)!.settings.arguments as Character;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 500,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              title: RickAndMortyLogo(),
              centerTitle: true,
              background: Hero(
                tag: _character.id,
                child: ClipRRect(
                  child: Image.network(
                    _character.image,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.difference,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).highlightColor,
                    ),
                    frameBuilder: (_, child, ___, ____) => Stack(
                      children: [
                        Positioned.fill(child: child),
                        Positioned.fill(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .background
                                      .withOpacity(0),
                                  Theme.of(context).colorScheme.background,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.5, 1],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InformationCard(
                    title: Text('Name'),
                    content: Text(_character.name),
                  ),
                  _InformationCard(
                    title: Text('Status'),
                    content: Text(_character.status),
                  ),
                  _InformationCard(
                    title: Text('Gender'),
                    content: Text(_character.gender),
                  ),
                  _InformationCard(
                    title: Text('Species'),
                    content: Text(_character.species),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).splashColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
            child: title,
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium ?? TextStyle(),
            child: content,
          ),
        ],
      ),
    );
  }
}
