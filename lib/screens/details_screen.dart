import 'package:flutter/material.dart';
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

  var nameController = TextEditingController();
  var nickNameController = TextEditingController();

  _DetailScreenState(this.name);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);

    return FutureBuilder<Pokemon>(
        future: provider.getDetails(name),
        builder: (context, AsyncSnapshot<Pokemon> snapshot) {
          if(snapshot.hasData) {
            return _buildDetails(snapshot.requireData);
          } else if(snapshot.hasError) {
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

  _buildDetails(Pokemon details) {
    return Scaffold(
        body: Column(
      children: [
        Center(child:
          Text(details.name, style: Styles.screenTitleTextStyle)),
        Container(height: MediaQuery.of(context).size.width * 0.4),
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.2
            ),
            Positioned(
              right: 35,
              bottom: -50,
              left: 35,
              child: FadeInImage.assetNetwork(
                image: details.sprite,
                imageScale: 0.35,
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
              child: Column(

              )),
        ),
        _buildSaveForm(details.id)
      ],
    ));
  }

  _buildSaveForm(String id){



    return Form(
      key: _formKey,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Name'
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nickNameController,
                decoration: const InputDecoration(
                    labelText: 'Nickname'
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<PokemonProvider>(context, listen: false)
                        .saveToGallery(id, nameController.value.text, nickNameController.value.text)
                        .then((value) => Navigator.pop(context));
                  }
                },
                child: const Text('Save to Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
