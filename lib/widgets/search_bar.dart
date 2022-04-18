import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import '../screens/details_screen.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();
  late PokemonProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PokemonProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: provider.getNames(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return _buildSearch(snapshot.data!);
          } else if (snapshot.hasError) {
            return const SafeArea(
              child: Center(child: Text('Error')),
            );
          } else {
            return const SafeArea(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        }
    );
  }

  _buildSearch(List<String> pokemonNames) {
    return Container(
        margin: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          // color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: buildAutocomplete(pokemonNames));
  }

  buildAutocomplete(List<String> pokemonNames) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) =>
          _autoCompleteAction(textEditingValue, pokemonNames),
      onSelected: (String selection) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(name: selection)),
        );
      },
    );
  }

  Iterable<String> _autoCompleteAction(TextEditingValue textEditingValue, List<String> pokemonNames) {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }
    return pokemonNames.where((String option) {
      return option.contains(textEditingValue.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
