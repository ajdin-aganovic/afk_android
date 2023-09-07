

import 'package:afk_admin/models/bolest.dart';

import 'base_provider.dart';

class BolestProvider extends BaseProvider<Bolest>{

  BolestProvider():super("Bolest");

  @override
  Bolest fromJson(data) {
    // TODO: implement fromJson
    return Bolest.fromJson(data);
  }

}