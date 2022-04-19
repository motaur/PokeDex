import 'package:flutter/material.dart';
import 'package:poke/providers/pokemon_provider.dart';
import 'package:poke/ui/screens/home_screen.dart';
import 'package:poke/utils/strings.dart';
import 'package:provider/provider.dart';

import 'di.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => getIt.get<PokemonProvider>(),
      child: MaterialApp(
          title: Strings.pokeScreenTitle,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const HomeScreen()
      ),
    );
  }
}