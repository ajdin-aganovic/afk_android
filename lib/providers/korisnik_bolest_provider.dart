

import 'package:afk_admin/models/korisnik_bolest.dart';

import 'base_provider.dart';

class KorisnikBolestProvider extends BaseProvider<KorisnikBolest>{

  KorisnikBolestProvider():super("KorisnikBolest");

  @override
  KorisnikBolest fromJson(data) {
    // TODO: implement fromJson
    return KorisnikBolest.fromJson(data);
  }

}