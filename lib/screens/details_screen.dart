import 'package:flutter/material.dart';
import 'package:poke/models/gallery_name.dart';
import 'package:provider/provider.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../utils/styles.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/detailScreen';
  final String name;

  const DetailsScreen({Key? key, required this.name}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(name);
}

class _DetailScreenState extends State<DetailsScreen> {

  final String name;
  final _formKey = GlobalKey<FormState>();
  final _galleryNameController = TextEditingController();
  GalleryName? _galleryName;

  _DetailScreenState(this.name);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);

    return FutureBuilder<Pokemon>(
        future: provider.getDetails(name),
        builder: (context, AsyncSnapshot<Pokemon> snapshot) {
          if (snapshot.hasData) {
            return _buildDetails(snapshot.requireData);
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

  _buildDetails(Pokemon details) {
    return Scaffold(
        body: Column(
      children: [
        Center(child: Text(details.name, style: Styles.screenTitleTextStyle)),
        Container(height: MediaQuery.of(context).size.width * 0.4),
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.2),
            Positioned(
              right: 35,
              bottom: -50,
              left: 35,
              child: FadeInImage.assetNetwork(
                image: details.sprite,
                placeholderScale: 0.1,
                placeholder: 'images/loading.gif',
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column()),
        ),
        _buildSaveForm(details.id)
      ],
    ));
  }

  _buildSaveForm(String id) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: GalleryName.name,
                      onChanged: (newValue) => setState(() {
                        _galleryName = newValue as GalleryName;
                      }),
                      groupValue: _galleryName,
                    ),
                    const Text('Name'),
                    Radio(
                      value: GalleryName.nickname,
                      groupValue: _galleryName,
                      onChanged: (newValue) => setState(() {
                        _galleryName = newValue as GalleryName;
                      })
                    ),
                    const Text('Nick'),
                  ]),

              TextFormField(
                controller: _galleryNameController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The field should content at least 1 character';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_galleryName != null && _formKey.currentState!.validate()) {
                      Provider.of<PokemonProvider>(context, listen: false)
                          .saveToGallery(id, _galleryNameController.value.text, _galleryName!)
                          .then((value) => Navigator.pop(context));
                    }
                  },
                  child: const Text('Save to Gallery'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _galleryNameController.dispose();
    super.dispose();
  }
}
