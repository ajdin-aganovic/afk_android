import 'package:json_annotation/json_annotation.dart';
part 'stadion.g.dart';

@JsonSerializable()
class Stadion{
   int? stadionId;

String? nazivStadiona;

int? kapacitetStadiona ;


  Stadion(this.stadionId, this.nazivStadiona, this.kapacitetStadiona);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory Stadion.fromJson(Map<String,dynamic>json)=>_$StadionFromJson(json);
  Map<String,dynamic>toJson()=>_$StadionToJson(this);
}
