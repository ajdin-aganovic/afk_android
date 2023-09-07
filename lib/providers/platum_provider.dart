

import 'package:afk_android/models/platum.dart';

import 'base_provider.dart';

class PlatumProvider extends BaseProvider<Platum>{
  PlatumProvider(): super("Platum");


  @override
  Platum fromJson(data) {
    // TODO: implement fromJson
    return Platum.fromJson(data);
  }

  }