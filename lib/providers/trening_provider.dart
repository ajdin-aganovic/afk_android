

import 'package:afk_admin/models/trening.dart';

import 'base_provider.dart';

class TreningProvider extends BaseProvider<Trening>{

  TreningProvider():super("Trening");

  @override
  Trening fromJson(data) {
    // TODO: implement fromJson
    return Trening.fromJson(data);
  }

}