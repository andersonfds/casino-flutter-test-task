import 'package:casino_test/src/data/models/character.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    required this.character,
    Key? key,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 2,
      ),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/details', arguments: character);
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Hero(
                  tag: character.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        character.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text('Gender: ${character.gender}'),
                    Text('Status: ${character.status}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
