

import 'package:afk_admin/models/statistika.dart';

import 'base_provider.dart';

class StatistikaProvider extends BaseProvider<Statistika>{

  StatistikaProvider():super("Statistika");

  @override
  Statistika fromJson(data) {
    // TODO: implement fromJson
    return Statistika.fromJson(data);
  }

}