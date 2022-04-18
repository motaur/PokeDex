import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:poke/models/gallery_name.dart';
import 'package:poke/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../utils/styles.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late TabController _tabController;
  late PokemonProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PokemonProvider>(context, listen: false);
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildHomeScreen();
  }

  Widget _buildHomeScreen() {
      var deviceScreenSize = MediaQuery.of(context).size;
      return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Padding(
              padding: EdgeInsets.all(deviceScreenSize.width * 0.05),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    _screenTitle(),
                    _searchBar(deviceScreenSize),
                    _loadGallery(deviceScreenSize),
                  ]),
            ),
          )
      );
    }

  Widget _searchBar(Size deviceScreenSize) => const SearchBar();

  Widget _loadGallery(Size size) {
    return FutureBuilder<Map<String, List<Pokemon>>>(
        future: provider.getSavedPokemons(),
        builder: (context, AsyncSnapshot<Map<String, List<Pokemon>>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildTabs(snapshot.data!);
          }
          else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const SafeArea(
                child:Center(child: Text("Nothing saved")));
          }
          else if (snapshot.hasError) {
            return const SafeArea(
              child: Center(child: Text('Error')),
            );
          }
          else {
            return const SafeArea(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget _buildTabs(Map<String, List<Pokemon>> data) {
    _tabController = TabController(length: data.length+1, vsync: this);

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

  List<Widget> _buildGrids(Map<String, List<Pokemon>> data){
    var allPokemons = _mergeLists(data);
    List<Widget> grids = [];

    //1st tab all pokemons
    grids.add(
      GridView.count(
        crossAxisCount: 2,
        children: List.generate(allPokemons.length, (index) => _buildCard(index, allPokemons))),
    );
    //rest of tabs by type
    data.forEach((key, value) {
      grids.add(
          GridView.count(
              crossAxisCount: 2,
              children: List.generate(value.length, (index) => _buildCard(index, value)))
      );
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

  Widget _buildCard(int i, List<Pokemon> data){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 5,
          child: Column(
            children: [

              Text(data[i].name),

              FadeInImage.assetNetwork(
                fit: BoxFit.fitHeight,
                image: data[i].sprite,
                imageScale: 0.2,
                placeholderScale: 0.1,
                placeholder: 'images/loading.gif',
              ),

              data[i].galleryName == GalleryName.name ?
                Text("Name: ${data[i].givenName!}") : Text("Nickname: ${data[i].givenName!}"),

              Text(data[i].type1)


            ],
          )
      ),
    );
  }

  Widget _buildTabBar(Map<String, List<Pokemon>> data) {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.black,
      unselectedLabelColor: Colors.black,
      indicator: Styles.indicatorBoxStyle,
      tabs: _buildTabsByType(data),
    );
  }

  List<Widget> _buildTabsByType(Map<String, List<Pokemon>> data){
    List<Widget> tabs = [];

    tabs.add(const Tab(text: "All"));

    for (var key in data.keys) {
      tabs.add(Tab(text: key));
    }
    return tabs;
  }

  _screenTitle() => Center(child: Text(Strings.pokeScreenTitle, style: Styles.screenTitleTextStyle));

  @override
  void dispose() {
   _tabController.dispose();
    super.dispose();
  }
}

