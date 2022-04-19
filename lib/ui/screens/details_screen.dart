import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke/models/gallery_name.dart';
import 'package:provider/provider.dart';

import '../../models/pokemon.dart';
import '../../providers/pokemon_provider.dart';
import '../../utils/strings.dart';
import '../../utils/styles.dart';
import '../../utils/utils.dart';

class DetailsScreen extends StatefulWidget {
  final String name;

  const DetailsScreen({Key? key, required this.name}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(name);
}

class _DetailScreenState extends State<DetailsScreen> {
  final String _name;
  final _formKey = GlobalKey<FormState>();
  final _galleryNameController = TextEditingController();
  GalleryNameType? _galleryNameType;

  _DetailScreenState(this._name);

  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonProvider>(builder: _detailsScreenEntryPoint);
  }

  Widget _detailsScreenEntryPoint(BuildContext context,
          PokemonProvider pokemonProvider, Widget? ignored) =>
      WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(title: const Text(Strings.pokeScreenTitle)),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Pokemon>(
                  future: pokemonProvider.getDetails(_name),
                  builder: (context, AsyncSnapshot<Pokemon> snapshot) {
                    if (snapshot.hasData) {
                      return _buildDetails(
                          snapshot.requireData, pokemonProvider);
                    } else if (snapshot.hasError) {
                      return const Center(child: Text(Strings.failed));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
        ),
      );

  _buildDetails(Pokemon details, PokemonProvider pokemonProvider) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(child: _screenTitle(details.name.toUpperCase())),
        SizedBox(
          width: 200,
          height: 200,
          child: FadeInImage.assetNetwork(
            fit: BoxFit.fitHeight,
            image: details.sprite,
            placeholder: 'images/trans.png',
          ),
        ),
        Expanded(
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  ),
              child: Column(
                children: [
                  Text(Strings.type + ": ${details.type}"),
                  Text(Strings.weight +
                      ": ${lbsToKg(details.weight).toStringAsFixed(1)} ${Strings.kg}")
                ],
              )),
        ),
        _buildSaveForm(details, pokemonProvider)
      ],
    ));
  }

  _buildSaveForm(Pokemon details, PokemonProvider pokemonProvider) {
    if (details.galleryNameType != null) {
      _galleryNameType = details.galleryNameType;
      _galleryNameController.text = details.galleryName!;
    }

    return Form(
      key: _formKey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: GalleryNameType.name,
                      onChanged: (newValue) => setState(() {
                        _galleryNameType = newValue as GalleryNameType;
                      }),
                      groupValue: _galleryNameType,
                    ),
                    const Text(Strings.name),
                    Radio(
                        value: GalleryNameType.nickname,
                        groupValue: _galleryNameType,
                        onChanged: (newValue) => setState(() {
                              _galleryNameType = newValue as GalleryNameType;
                            })),
                    const Text(Strings.nickname),
                  ]),
              if (_galleryNameType != null)
                _galleryName(details, pokemonProvider)
            ],
          ),
        ),
      ),
    );
  }

  _galleryName(Pokemon details, PokemonProvider pokemonProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: TextFormField(
            controller: _galleryNameController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if ((value == null || value.isEmpty)) {
                return Strings.nameValidation;
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: ElevatedButton(
            onPressed: () {
              if (details.galleryNameType != null) {
                pokemonProvider
                    .deleteFromGallery(details.id)
                    .then((value) => Navigator.pop(context));
              } else if ((_galleryNameType != null &&
                      _formKey.currentState!.validate()) &&
                  _galleryNameType != null) {
                pokemonProvider
                    .saveToGallery(details.id,
                        _galleryNameController.value.text, _galleryNameType!)
                    .then((value) => Navigator.pop(context));
              }
            },
            child: details.galleryNameType != null
                ? const Text(Strings.deleteFromGallery)
                : const Text(Strings.saveToGallery),
          ),
        )
      ],
    );
  }

  _screenTitle(String title) =>
      Center(child: Text(title, style: Styles.screenTitleTextStyle));

  Future<bool> _onWillPop() async {
    if (_galleryNameType != null || _galleryNameController.text.isNotEmpty) {
      return (await showCupertinoModalPopup(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(Strings.sureExit),
              content: const Text(Strings.changesWillLost),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(Strings.no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(Strings.yes),
                ),
              ],
            ),
          )) ??
          false;
    } else {
      Navigator.of(context).pop(true);
      return true;
    }
  }

  @override
  void dispose() {
    _galleryNameController.dispose();
    super.dispose();
  }
}
