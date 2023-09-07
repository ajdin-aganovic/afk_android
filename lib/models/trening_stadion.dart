import 'package:json_annotation/json_annotation.dart';
part 'trening_stadion.g.dart';

@JsonSerializable()
class TreningStadion{
int? treningStadionId;

int? treningId;

int? stadionId;


  TreningStadion(this.treningStadionId, this.treningId, this.stadionId);
  // factory Korisnici.fromJson(Map<String,dynamic>json)=>_$KorisniciFromJson(json);

  factory TreningStadion.fromJson(Map<String,dynamic>json)=>_$TreningStadionFromJson(json);
  Map<String,dynamic>toJson()=>_$TreningStadionToJson(this);
}