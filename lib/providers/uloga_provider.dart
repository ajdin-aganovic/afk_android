

import 'package:afk_android/models/uloga.dart';

import 'base_provider.dart';

class UlogaProvider extends BaseProvider<Uloga>{

  UlogaProvider():super("Uloga");

  @override
  Uloga fromJson(data) {
    // TODO: implement fromJson
    return Uloga.fromJson(data);
  }

}