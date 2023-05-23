import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class RickAndMortyLogo extends StatelessWidget {
  const RickAndMortyLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'rick_and_morty_logo',
      child: SvgPicture.asset(
        'assets/images/logo_rnm.svg',
        height: 40,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
