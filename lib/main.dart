import 'package:flutter/material.dart';
import 'package:poke/utils/colors.dart';
import 'package:poke/utils/strings.dart';
import 'package:poke/utils/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
                buildAutocomplete(),
                _buildTabs(deviceScreenSize),
              ]),
          ),
      )
    );
         
  }

   _buildTabs(Size size) =>
     Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Container(
            decoration: PokeStyles.tabsBoxDecoration,
            child: _pokeTabBar(),
          ),
          Container(
            constraints: BoxConstraints(minWidth: 400),
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  decoration: PokeStyles.tabsPagesBoxDecoration,
                  child: Center(
                    child: Text("It's cloudy here"),
                  ),
                ),
                Center(
                  child: Text("It's rainy here"),
                ),
                Center(
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

  Autocomplete<User> buildAutocomplete() {

    return Autocomplete<User>(
      displayStringForOption: _displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<User>.empty();
        }
        return _userOptions.where((User option) {
          return option
              .toString()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (User selection) {
        debugPrint(
            'You just selected ${_displayStringForOption(selection)}');
      },
    );
  }

  static String _displayStringForOption(User option) => option.name;

  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];
}

@immutable
class User {
  const User({
    required this.email,
    required this.name,
  });

  final String email;
  final String name;

  @override
  String toString() {
    return '$name, $email';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => hashValues(email, name);
}
