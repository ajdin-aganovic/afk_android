

import 'package:afk_admin/models/korisnik_pozicija.dart';

import 'base_provider.dart';

class KorisnikPozicijaProvider extends BaseProvider<KorisnikPozicija>{

  KorisnikPozicijaProvider():super("KorisnikPozicija");

  @override
  KorisnikPozicija fromJson(data) {
    // TODO: implement fromJson
    return KorisnikPozicija.fromJson(data);
  }

}