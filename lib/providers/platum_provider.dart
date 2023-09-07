

import 'package:afk_admin/models/platum.dart';

import 'base_provider.dart';

class PlatumProvider extends BaseProvider<Platum>{
  PlatumProvider(): super("Platum");


  @override
  Platum fromJson(data) {
    // TODO: implement fromJson
    return Platum.fromJson(data);
  }

  }