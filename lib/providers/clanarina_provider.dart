

import 'package:afk_admin/models/clanarina.dart';

import 'base_provider.dart';

class ClanarinaProvider extends BaseProvider<Clanarina>{

  ClanarinaProvider():super("Clanarina");

  @override
  Clanarina fromJson(data) {
    // TODO: implement fromJson
    return Clanarina.fromJson(data);
  }

}