import 'package:flutter/material.dart';
import 'package:poke/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';
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
    _tabController = TabController(length: 3, vsync: this);
    Provider.of<PokemonProvider>(context, listen: false).getNames();
  }
  
  @override
  Widget build(BuildContext context) {
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
                  _buildTabs(deviceScreenSize),
                ]),
          ),
        )
    );

  }

  _searchBar(Size deviceScreenSize) => const HomeSearch();

  _buildTabs(Size size) =>
      Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          children: [
            Container(
              decoration: PokeStyles.tabsBoxDecoration,
              child: _pokeTabBar(),
            ),
            SizedBox(
              height: 250,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    decoration: PokeStyles.tabsPagesBoxDecoration,
                    child: const Center(
                      child: Text("It's cloudy here"),
                    ),
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

  ///Returns tabs
  _pokeTabBar() =>
      TabBar(
        controller: _tabController,
        labelColor: AppColors.black,
        unselectedLabelColor: Colors.black,
        indicator: PokeStyles.indicatorBoxStyle,
        tabs: const <Widget> [
          Tab(text: Strings.all),
          Tab(text: Strings.fire),
          Tab(text: Strings.grass),
        ],
      );



  ///Returns screen title widget
  _screenTitle() => Center(child: Text(Strings.pokeScreenTitle, style: PokeStyles.screenTitleTextStyle));
}
