import 'package:json_annotation/json_annotation.dart';
part 'platum.g.dart';

@JsonSerializable()
class Platum{
  int? plataId;
  int? transakcijskiRacunId;
  String? stateMachine;
  num? iznos;
  // String? datumSlanja;
  DateTime? datumSlanja;

  Platum(this.plataId, this.transakcijskiRacunId, this.stateMachine, this.iznos, this.datumSlanja);
  factory Platum.fromJson(Map<String,dynamic>json)=>_$PlatumFromJson(json);
  Map<String,dynamic>toJson()=>_$PlatumToJson(this);
}


// "plataId": 0,
// "korisnikId": 0,
// "stateMachine": "string",
// "iznos": 0,
// "datumSlanja": "2023-06-20T12:28:32.348Z",