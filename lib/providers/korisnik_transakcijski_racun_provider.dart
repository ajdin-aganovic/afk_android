

import 'package:afk_android/models/korisnik_transakcijski_racun.dart';

import 'base_provider.dart';

class KorisnikTransakcijskiRacunProvider extends BaseProvider<KorisnikTransakcijskiRacun>{

  KorisnikTransakcijskiRacunProvider():super("KorisnikTransakcijskiRacun");

  @override
  KorisnikTransakcijskiRacun fromJson(data) {
    // TODO: implement fromJson
    return KorisnikTransakcijskiRacun.fromJson(data);
  }

}