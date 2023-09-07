

import 'package:afk_admin/models/korisnik_uloga.dart';

import 'base_provider.dart';

class KorisnikUlogaProvider extends BaseProvider<KorisnikUloga>{

  KorisnikUlogaProvider():super("KorisnikUloga");

  @override
  KorisnikUloga fromJson(data) {
    // TODO: implement fromJson
    return KorisnikUloga.fromJson(data);
  }

}