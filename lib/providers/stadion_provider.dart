

import 'package:afk_admin/models/stadion.dart';

import 'base_provider.dart';

class StadionProvider extends BaseProvider<Stadion>{

  StadionProvider():super("Stadion");

  @override
  Stadion fromJson(data) {
    // TODO: implement fromJson
    return Stadion.fromJson(data);
  }

}