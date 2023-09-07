

import 'package:afk_android/models/trening.dart';

import 'base_provider.dart';

class TreningProvider extends BaseProvider<Trening>{

  TreningProvider():super("Trening");

  @override
  Trening fromJson(data) {
    // TODO: implement fromJson
    return Trening.fromJson(data);
  }

}