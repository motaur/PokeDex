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
  final bool _validate = false;
  late List<String> pokemonNames;

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<PokemonProvider>(context);
    pokemonNames = provider.pokemonNames;

    return Container(
      margin: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: buildAutocomplete()
    );
  }

  buildAutocomplete() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) => _autoCompleteAction(textEditingValue),
      onSelected: (String selection) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(name: selection)),
        );
      },
    );
  }

  Iterable<String> _autoCompleteAction(TextEditingValue textEditingValue) {
      if (textEditingValue.text == '') {
        return const Iterable<String>.empty();
      }
      return pokemonNames.where((String option) {
        return option
            .contains(textEditingValue.text.toLowerCase());
      });
  }

  buildSearchTextField(){
    return TextField(
          style: const TextStyle(color: Colors.black),
          maxLines: 1,
          controller: _textController,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey[600]),
            errorText: _validate ? null : null,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            icon: const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            hintText: "What Pokémon are you looking for? ",
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              // Navigator.of(context)
              //     .pushNamed(PokeDetailScreen.routeName, arguments: value);
            }
          },
        );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}