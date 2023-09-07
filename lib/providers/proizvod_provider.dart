

import 'package:afk_android/models/proizvod.dart';

import 'base_provider.dart';

class ProizvodProvider extends BaseProvider<Proizvod>{

  ProizvodProvider():super("Proizvod");

  @override
  Proizvod fromJson(data) {
    // TODO: implement fromJson
    return Proizvod.fromJson(data);
  }

}