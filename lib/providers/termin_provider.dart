

import 'package:afk_admin/models/termin.dart';

import 'base_provider.dart';

class TerminProvider extends BaseProvider<Termin>{

  TerminProvider():super("Termin");

  @override
  Termin fromJson(data) {
    // TODO: implement fromJson
    return Termin.fromJson(data);
  }

}