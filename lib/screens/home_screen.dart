import 'package:flutter/material.dart';
import 'package:poke/models/gallery_name.dart';
import 'package:poke/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

import '../models/pokemon.dart';
import '../utils/strings.dart';
import '../utils/styles.dart';
import '../utils/utils.dart';
import '../widgets/search_bar.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<PokemonProvider>(builder: _buildHomeScreen);

  Widget _buildHomeScreen(
      BuildContext context, PokemonProvider pokemonProvider, Widget? ignored) {
    var deviceScreenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.pokeScreenTitle),
    ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(deviceScreenSize.width * 0.05),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          _screenTitle(),
          const SearchBar(),
          _loadGallery(
              pokemonProvider: pokemonProvider, size: deviceScreenSize),
        ]),
      ),
    ));
  }

  Widget _loadGallery(
      {required PokemonProvider pokemonProvider, required Size size}) {
    return FutureBuilder<Map<String, List<Pokemon>>>(
        future: pokemonProvider.getSavedPokemons(),
        builder: (context, AsyncSnapshot<Map<String, List<Pokemon>>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildTabs(snapshot.data!);
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const SafeArea(
                child: Center(child: Text("Nothing saved in Gallery")));
          } else if (snapshot.hasError) {
            return const SafeArea(
              child: Center(child: Text('Error')),
            );
          } else {
            return const SafeArea(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget _buildTabs(Map<String, List<Pokemon>> data) {
    _tabController = TabController(length: data.length + 1, vsync: this);

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Container(
            decoration: Styles.tabsBoxDecoration,
            child: _buildTabBar(data),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: TabBarView(
              controller: _tabController,
              children: _buildGrids(data),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGrids(Map<String, List<Pokemon>> data) {
    var allPokemons = _mergeLists(data);
    List<Widget> grids = [];

    //1st tab all pokemons
    grids.add(
      GridView.count(
          crossAxisCount: 2,
          children: List.generate(
              allPokemons.length, (index) => _buildCard(index, allPokemons))),
    );
    //rest of tabs by type
    data.forEach((key, value) {
      grids.add(GridView.count(
          crossAxisCount: 2,
          children: List.generate(
              value.length, (index) => _buildCard(index, value))));
    });

    return grids;
  }

  List<Pokemon> _mergeLists(Map<String, List<Pokemon>> data) {
    List<Pokemon> allPokemons = [];

    data.forEach((key, value) {
      for (var element in value) {
        allPokemons.add(element);
      }
    });

    return allPokemons;
  }

  Widget _buildCard(int i, List<Pokemon> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsScreen(name: data[i].id)),
          );
        },
        child: _pokemonCard(data, i),
      ),
    );
  }

  _pokemonCard(List<Pokemon> data, int i) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          // color: Colors.white,
          border: Border.all(
            width: 1,
            // color: AppColors.gray200
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(data[i].name),
                SizedBox(
                  width: 86,
                  height: 86,
                  child: _imageWidget(data, i),
                ),
                data[i].galleryNameType == GalleryNameType.name
                    ? Text('${Strings.name}: ${data[i].galleryName!}')
                    : Text('${Strings.nickname}: ${data[i].galleryName!}'),
                Text(Strings.type + ": ${data[i].type}"),
                Text(Strings.weight +
                    ": ${lbsToKg(data[i].weight).toStringAsFixed(1)} ${Strings.kg}"),
              ],
            ),
          ),
        ),
      ));

  ///Returns pokemon's image from network
  _imageWidget(List<Pokemon> data, int i) => FadeInImage.assetNetwork(
        fit: BoxFit.fitHeight,
        image: data[i].sprite,
        imageScale: 0.2,
        placeholderScale: 0.1,
        placeholder: 'images/trans.png',
      );

  Widget _buildTabBar(Map<String, List<Pokemon>> data) {
    return TabBar(
      controller: _tabController,
      unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
      labelColor: Theme.of(context).tabBarTheme.labelColor,
      automaticIndicatorColorAdjustment: true,
      indicator: Styles.indicatorBoxStyle,
      tabs: _buildTabsByType(data),
    );
  }

  List<Widget> _buildTabsByType(Map<String, List<Pokemon>> data) {
    List<Widget> tabs = [];

    tabs.add(const Tab(text: "All"));

    for (var key in data.keys) {
      tabs.add(Tab(text: key));
    }
    return tabs;
  }

  _screenTitle() => Center(
      child: Text(Strings.pokeScreenTitle, style: Styles.screenTitleTextStyle));

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
