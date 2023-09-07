

import 'package:afk_admin/models/pozicija.dart';

import 'base_provider.dart';

class PozicijaProvider extends BaseProvider<Pozicija>{

  PozicijaProvider():super("Pozicija");

  @override
  Pozicija fromJson(data) {
    // TODO: implement fromJson
    return Pozicija.fromJson(data);
  }

}