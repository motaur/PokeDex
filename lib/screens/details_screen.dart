import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/detailScreen';
  final String name;

  const DetailsScreen({Key? key, required this.name}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(name);
}

class _DetailScreenState extends State<DetailsScreen> {
  final String name;

  _DetailScreenState(this.name);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);

    return FutureBuilder<Pokemon>(
        future: provider.getDetails(name),
        builder: (context, AsyncSnapshot<Pokemon> snapshot) {
          if(snapshot.hasData) {
            return _buildDetails(snapshot.requireData);
          } else if(snapshot.hasError) {
            return const Text('Error');
          }
          else {
            return const CircularProgressIndicator();
          }
        });
  }

  _buildDetails(Pokemon details) {
    return Scaffold(
        body: Column(
      children: [
        Container(height: MediaQuery.of(context).size.width / 2),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 4.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
            Positioned(
              right: 35,
              bottom: -50,
              left: 35,
              child: FadeInImage.assetNetwork(
                image: details.sprite,
                imageScale: 0.35,
                placeholder: '',
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column()),
        ),
      ],
    ));
  }
}
