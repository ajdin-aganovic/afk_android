import '../models/narudzba.dart';
import 'base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzba");

  @override
  fromJson(data) {
    // TODO: implement fromJson
    return Narudzba.fromJson(data);
  }
}