import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pokemon_provider.dart';
import '../../utils/strings.dart';
import '../screens/details_screen.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();
  late PokemonProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<PokemonProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _provider.getNames(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return _buildSearch(snapshot.data!);
          } else if (snapshot.hasError) {
            return const SafeArea(
              child: Center(child: Text(Strings.failed)),
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
      fieldViewBuilder: (context, _textController, focusNode, onEditingComplete) {
        return TextField(
          controller: _textController,
          focusNode: focusNode,
          onEditingComplete: () {
            if(pokemonNames.contains(_textController.text)){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsScreen(name: _textController.text)),
              );
            }
            else {
              FocusManager.instance.primaryFocus?.unfocus();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(Strings.foundNothing),
              ));
            }
            },
          decoration: InputDecoration(
              hintText: Strings.searchForPokemon,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              prefixIcon: const Icon(Icons.search)),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) =>
          _autoCompleteAction(textEditingValue, pokemonNames),
      onSelected: (String selection) {
        _textController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(name: selection)),
        );
      },
    );
  }

  Iterable<String> _autoCompleteAction(TextEditingValue textEditingValue, List<String> pokemonNames) {
    if (textEditingValue.text.length < 2) {
      return const Iterable<String>.empty();
    } else {
      pokemonNames.sort();
      return pokemonNames.where((String option) {
        return option.contains(textEditingValue.text.toLowerCase());
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
