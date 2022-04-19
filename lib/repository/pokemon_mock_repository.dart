import 'package:poke/repository/pokemon_api_repository.dart';

class PokemonMockRepository implements PokemonApiRepository {

  @override
  Future<Map<String, dynamic>> getDetails(String name) {
    // TODO: implement getDetails
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getNames() {
    // TODO: implement getNames
    throw UnimplementedError();
  }

}