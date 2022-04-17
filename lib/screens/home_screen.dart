import 'package:flutter/material.dart';
import 'package:poke/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../utils/styles.dart';
import '../widgets/home_search.dart';

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
    Provider.of<PokemonProvider>(context, listen: false).getNames();
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

  Widget _searchBar(Size deviceScreenSize) => const HomeSearch();

  Widget _loadGallery(Size size) {
    return FutureBuilder<List<Pokemon>>(
        future: Provider.of<PokemonProvider>(context, listen: false).getSavedPokemons(),
        builder: (context, AsyncSnapshot<List<Pokemon>> snapshot) {
          if (snapshot.hasData && Provider.of<PokemonProvider>(context, listen: false).gallery.isNotEmpty) {
            return _buildTabs(snapshot.data!);
          }
          else if (snapshot.hasData && Provider.of<PokemonProvider>(context, listen: false).gallery.isEmpty) {
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

  Widget _buildTabs(List<Pokemon> data) {
    _tabController = TabController(length: 3, vsync: this);
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Container(
            decoration: Styles.tabsBoxDecoration,
            child: _pokeTabBar(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  decoration: Styles.tabsPagesBoxDecoration,
                  child: GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(Provider
                          .of<PokemonProvider>(context, listen: false)
                          .gallery
                          .length, (index) => _buildCard(index))),
                ),
                const Center(
                  child: Text("It's rainy here"),
                ),
                const Center(
                  child: Text("It's sunny here"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(int i){
    var gallery = Provider.of<PokemonProvider>(context, listen: false).gallery;
    return Card(
        elevation: 5,
        child: Column(
          children: [
            Text(gallery[i].name)
          ],
        )
    );
  }
  Widget _pokeTabBar() =>
        TabBar(
          controller: _tabController,
          labelColor: AppColors.black,
          unselectedLabelColor: Colors.black,
          indicator: Styles.indicatorBoxStyle,
          tabs: const <Widget> [
            Tab(text: Strings.all),
            Tab(text: Strings.fire),
            Tab(text: Strings.grass),
          ],
        );

  _screenTitle() => Center(child: Text(Strings.pokeScreenTitle, style: Styles.screenTitleTextStyle));
}

