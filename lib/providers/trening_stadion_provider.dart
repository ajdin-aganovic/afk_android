

import 'package:afk_android/models/trening_stadion.dart';

import 'base_provider.dart';

class TreningStadionProvider extends BaseProvider<TreningStadion>{

  TreningStadionProvider():super("TreningStadion");

  @override
  TreningStadion fromJson(data) {
    // TODO: implement fromJson
    return TreningStadion.fromJson(data);
  }

}