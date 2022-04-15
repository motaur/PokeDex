import 'package:flutter/material.dart';
import 'package:poke/widgets/search_bar.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: const SearchBar(),
    );
  }
}