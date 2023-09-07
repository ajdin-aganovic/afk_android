

import 'package:afk_admin/models/transakcijski_racun.dart';

import 'base_provider.dart';

class TransakcijskiRacunProvider extends BaseProvider<TransakcijskiRacun>{

  TransakcijskiRacunProvider():super("TransakcijskiRacun");

  @override
  TransakcijskiRacun fromJson(data) {
    // TODO: implement fromJson
    return TransakcijskiRacun.fromJson(data);
  }

}