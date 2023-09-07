

import 'package:afk_admin/models/uloga.dart';

import 'base_provider.dart';

class UlogaProvider extends BaseProvider<Uloga>{

  UlogaProvider():super("Uloga");

  @override
  Uloga fromJson(data) {
    // TODO: implement fromJson
    return Uloga.fromJson(data);
  }

}