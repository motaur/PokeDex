import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../utils/strings.dart';
import '../utils/styles.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();
  final bool _validate = false;

  @override
  Widget build(BuildContext context) {
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
    return Autocomplete<Pokemon>(
      displayStringForOption: _displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) => _autoCompleteAction(textEditingValue),
      onSelected: (Pokemon selection) {
        debugPrint(
            'You just selected ${_displayStringForOption(selection)}');
      },
    );
  }

  Iterable<Pokemon> _autoCompleteAction(TextEditingValue textEditingValue) {
      if (textEditingValue.text == '') {
        return const Iterable<Pokemon>.empty();
      }
      return _pokemonOptions.where((Pokemon option) {
        return option
            .name
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

  static String _displayStringForOption(Pokemon option) => option.name;

  static const List<Pokemon> _pokemonOptions = <Pokemon>[
    Pokemon(id: 1, name: "Alice"),
    Pokemon(id: 2, name: "Bob"),
    Pokemon(id: 3, name: "pokemon")
    // Pokemon(name: 'Bob', email: 'bob@example.com'),
    // Pokemon(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}